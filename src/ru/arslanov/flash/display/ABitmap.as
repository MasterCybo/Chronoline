package ru.arslanov.flash.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.display.PixelSnapping;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.core.events.EventManager;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.interfaces.IKillable;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ABitmap extends Bitmap implements IKillable {
		
		static private var _counter:Number = 0;
		
		public var customData:Object;// Для хранения пользовательских данных
		
		/**
		 * Если установлен в true, то при вызове метода kill(), будет выполнен bitmapData.dispose()
		 */
		public var disposeOnKill:Boolean = true;
		
		
		private var _uid:Number = 0;
		private var _isKilled:Boolean;
		private var _isInited:Boolean;
		private var _eventManager:EventManager;
		//private var _mouseEnabled:Boolean;
		
		/**
		 * Создание экземпляра из Класса
		 * @param	className
		 * @return
		 */
		static public function fromClass( className:Class, width:uint = 0, height:uint = 0 ):ABitmap {
			var src:* = new className();
			var bmp:ABitmap;
			
			if ( src is BitmapData ) {
				bmp = new ABitmap( src );
				
			} else if ( src is Bitmap ) {
				bmp = new ABitmap( ( src as Bitmap ).bitmapData );
			}
			
			if ( ( width > 0 ) && ( height > 0 ) ) {
				bmp.setSize( width, height );
			}
			
			return bmp;
		}
		
		static public function fromColor( color:uint, width:uint, height:uint, transparent:Boolean = false ):ABitmap {
			return new ABitmap( new BitmapData( width, height, transparent, color ) );
		}
		
		/**
		 * Делает снимок с целевого объекта.
		 * Пример : ABitmap.fromDisplayObject( cont, null, { matrix:mtx, smoothing:true } ).init();
		 * @param	object - целевой объект, с которого будет снят снимок
		 * @param	paramsBitmapData - объект c параметрами для экземпляра BitmapData( ..., transparent:Boolean = false, fillColor:uint = uint.MAX_VALUE );
		 *
		 * @param	paramsDraw - объект c параметрами метода BitmapData.draw( ..., matrix:Matrix = null, colorTransform:flash.geom:ColorTransform = null
		 * 																		, blendMode:String (flash.display.BlendMode) = null, clipRect:Rectangle = null, smoothing:Boolean = false );
		 *
		 * @param	paramsBitmap - объект c параметрами для экземпляра Bitmap( ..., pixelSnapping:String = PixelSnapping.ALWAYS, smoothing:Boolean = false );
		 * @return	ABitmap
		 *
		 */
		static public function fromDisplayObject( object:IBitmapDrawable, paramsBitmapData:Object = null, paramsDraw:Object = null, paramsBitmap:Object = null ):ABitmap {
			var bounds:Rectangle = object["getBounds"]( object );
			
			var ww:uint = uint( object["width"] * 3 );
			var hh:uint = uint( object["height"] * 3 );
			
			
			// BitmapData
			var transparent		:Boolean 	= ( paramsBitmapData && paramsBitmapData["transparent"] ) ? paramsBitmapData["transparent"] : false;
			var fillColor		:uint 		= ( paramsBitmapData && paramsBitmapData["fillColor"] ) ? paramsBitmapData["fillColor"] : uint.MAX_VALUE;
			
			if ( transparent ) fillColor = 0x00ff0000;
			
			
			// BitmapData.draw
			var matrix			:Matrix 		= ( paramsDraw && paramsDraw["matrix"] ) ? paramsDraw["matrix"] : null;
			var colorTransform	:ColorTransform = ( paramsDraw && paramsDraw["colorTransform"] ) ? paramsDraw["colorTransform"] : null;
			var blendMode		:String 		= ( paramsDraw && paramsDraw["blendMode"] ) ? paramsDraw["blendMode"] : null;
			var clipRect		:Rectangle 		= ( paramsDraw && paramsDraw["clipRect"] ) ? paramsDraw["clipRect"] : null;
			var bdSmoothing		:Boolean 		= ( paramsDraw && paramsDraw["smoothing"] ) ? paramsDraw["smoothing"] : false;
			
			
			// Bitmap
			var pixelSnapping:String = ( paramsBitmap && paramsBitmap["pixelSnapping"] ) ? paramsBitmap["pixelSnapping"] : PixelSnapping.ALWAYS;
			var bmpSmoothing:Boolean = ( paramsBitmap && paramsBitmap["smoothing"] ) ? paramsBitmap["smoothing"] : false;
			
			
			if ( ( bounds.x < 0 ) || (bounds.y < 0) ) {
				if ( !matrix ) {
					matrix = new Matrix();
				}
				
				matrix.translate( -bounds.x, -bounds.y );
			}
			
			var bd:BitmapData = new BitmapData( ww, hh, transparent, fillColor );
			bd.draw( object, matrix, colorTransform, blendMode, clipRect, bdSmoothing );

			var rect:Rectangle = bd.getColorBoundsRect( fillColor, fillColor, false );
			
			var bd2:BitmapData = new BitmapData( rect.width, rect.height, transparent, fillColor );
			bd2.draw( bd, null, null, null, null, bdSmoothing );
			
			return new ABitmap( bd2, pixelSnapping, bmpSmoothing );
		}
		
		/***************************************************************************
		Constructor
		***************************************************************************/
		public function ABitmap( bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = true ) {
			_uid = ++_counter;
			
			super( bitmapData, pixelSnapping, smoothing );
		}
		
		/**
		 * Метод инициализации экземпляра. Вызывать перед addChild
		 * @return ссылка на себя
		 */
		public function init():* {
			_isInited = true;
			// override me
			return this;
		}
		
		public function get isInited():Boolean {
			return _isInited;
		}
		
		/**
		 * Убивает экземпляр
		 */
		public function kill():void {
			if ( _isKilled ) throw new Error ( this + " ALREADY KILLED!" ).getStackTrace();
			
			if ( _eventManager ) _eventManager.dispose();
			_eventManager = null;
			
			if ( parent ) parent.removeChild( this );
			
			if ( disposeOnKill && super.bitmapData ) super.bitmapData.dispose();
			
			_isKilled = true;
			customData = null;
			
			// override me
		}
		
		public function get isKilled():Boolean {
			return _isKilled;
		}
		
		/**
		 * Уникальный идентификатор
		 */
		public function get uid():Number {
			return _uid;
		}
		
		public function get uidStr():String {
			return "0x" + uid.toString( 16 ).toUpperCase();
		}
		
		override public function toString():String {
			return "[" + getQualifiedClassName( this ).split( ":" ).pop() + " " + uidStr + "]";
		}
		
		public function toStringGeometry():String {
			return toString() + " x:" + x + ", y:" + y + ", width:" + width + ", height:" + height;
		}
		
		/* INTERFACE ru.arslanov.core.interfaces.IInteractiveObjectKillable */
		
		public function get eventManager():EventManager {
			if ( !_eventManager ) _eventManager = new EventManager( this );
			return _eventManager;
		}
		
		public function set mouseEnabled( value:Boolean ):void {
			//_mouseEnabled = value;
		}
		
		public function setXY( x:Number, y:Number, rounded:Boolean = true ):void {
			this.x = rounded ? Math.round( x ) : x;
			this.y = rounded ? Math.round( y ) : y;
		}
		
		public function setSize( width:Number, height:Number, rounded:Boolean = true ):void {
			this.width = rounded ? Math.round( width ) : width;
			this.height = rounded ? Math.round( height ) : height;
		}
		
	}

}
