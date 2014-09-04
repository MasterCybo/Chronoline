package ru.arslanov.flash.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;


	/**
	 * ...
	 * @author Artem
	 */
	public class Bmp9Scale extends ASprite {
		
		// Constants
		
		
		// Variables
		protected var _bitmapData:BitmapData;
		protected var _leftTop:Point;
		protected var _rightBottom:Point;
		protected var _isSmoothing:Boolean;
		protected var _isRepeat:Boolean;
		protected var _isShowGrid:Boolean;
		
		private var _width:int;
		private var _height:int;
		private var _parts:Vector.<Rectangle>;
		private var _tilesBd:Vector.<BitmapData>;
		
		// Objects
		
		// Function
		static public function createFromClass( className:Class, leftTop:Point = null, rightBottom:Point = null, repeat:Boolean = true, smoothing:Boolean = true, showGrid:Boolean = false ):Bmp9Scale {
			var src:* = new className();
			
			//trace( "( src is Bitmap ) : " + ( src is Bitmap ) );
			//trace( "( src is BitmapData ) : " + ( src is BitmapData ) );
			
			if ( src is Bitmap ) {
				return new Bmp9Scale( ( src as Bitmap ).bitmapData, leftTop, rightBottom, repeat, smoothing, showGrid );
			} else if ( src is BitmapData ) {
				return new Bmp9Scale( src, leftTop, rightBottom, repeat, smoothing, showGrid );
			}
			return null;
		}
		
		/**************************************************************************
		 *
		 * Constructor
		 *
		 **************************************************************************/

		/**
		 * @param	bitmapData - изображение
		 * @param	leftTop - левая верхняя точка деления
		 * @param	rightBottom - правая нижняя точка деления
		 */
		public function Bmp9Scale( bitmapData:BitmapData, leftTop:Point = null, rightBottom:Point = null, repeat:Boolean = true, smoothing:Boolean = true, showGrid:Boolean = false ) {
			_bitmapData = bitmapData;
			
			_isShowGrid = showGrid;
			_isRepeat = repeat;
			_isSmoothing = smoothing;
			
			_leftTop = leftTop;
			_rightBottom = rightBottom;
			
			super();
		}
		
		override public function init( ):* {
			if ( !_bitmapData ) {
				throw new ArgumentError( "BitmapData is null!" );
			}
			
			this.mouseChildren = false;
			
			if( !_leftTop ) _leftTop = new Point();
			if( !_rightBottom ) _rightBottom = new Point();
			
			_width = _bitmapData.width;
			_height = _bitmapData.height;
			
			if ( _leftTop.x > _width) _leftTop.x = _width;
			if ( _leftTop.y > _height) _leftTop.y = _height;
			
			if ( _rightBottom.x > _width - _leftTop.x ) _rightBottom.x = _width - _leftTop.x;
			if ( _rightBottom.y > _height - _leftTop.y ) _rightBottom.y = _height - _leftTop.y;
			
			_parts = new Vector.<Rectangle>( );
			_parts.push( new Rectangle( 0, 0, _leftTop.x, _leftTop.y ) );
			_parts.push( new Rectangle( _leftTop.x, 0, _width - _leftTop.x - _rightBottom.x, _leftTop.y ) );
			_parts.push( new Rectangle( _width - _rightBottom.x, 0, _rightBottom.x, _leftTop.y ) );
			_parts.push( new Rectangle( 0, _leftTop.y, _leftTop.x, _height - _leftTop.y - _rightBottom.y ) );
			_parts.push( new Rectangle( _leftTop.x, _leftTop.y, _width - _leftTop.x - _rightBottom.x, _height - _leftTop.y - _rightBottom.y ) );
			_parts.push( new Rectangle( _width - _rightBottom.x, _leftTop.y, _rightBottom.x, _height - _leftTop.y - _rightBottom.y ) );
			_parts.push( new Rectangle( 0, _height - _rightBottom.y, _leftTop.x, _rightBottom.y ) );
			_parts.push( new Rectangle( _leftTop.x, _height - _rightBottom.y, _width - _leftTop.x - _rightBottom.x, _rightBottom.y ) );
			_parts.push( new Rectangle( _width - _rightBottom.x, _height - _rightBottom.y, _rightBottom.x, _rightBottom.y ) );
			
			_tilesBd = new Vector.<BitmapData>();
			var bd:BitmapData;
			for(var i:uint = 0; i < _parts.length; i++) {
				if(_parts[i].width * _parts[i].height > 0) {
					bd = new BitmapData( _parts[i].width, _parts[i].height, true, 0xff0000 );
					bd.copyPixels( _bitmapData, _parts[i], new Point( 0, 0 ) );
					_tilesBd.push( bd.clone() );
				}
			}
			
			bd.dispose();
			bd = null;
			
			build();
			
			return super.init();
		}
		
		/**************************************************************************
		 * Public
		 **************************************************************************/
		override public function addChild( child:DisplayObject ):DisplayObject {
			child;
			throw new Error( "Объект " + this + " : запрещено использовать метод addChild( )" );
			return null;
		}
		
		/**************************************************************************
		 * Private
		 **************************************************************************/
		private function build():void {
			removeTiles();
			
			var tile:Shape;
			var id:uint = 0;
			var matrix:Matrix;
			var repeat:Boolean;
			
			for( var i:uint = 0; i < _parts.length; i++ ) {
				if( _parts[i].width * _parts[i].height > 0 ) {
					tile = new Shape();
					matrix = new Matrix();
					
					if( !_isRepeat ) {
						matrix.scale( _parts[i].width / _tilesBd[id].width, _parts[i].height / _tilesBd[id].height );
					}
					
					repeat = _isRepeat;
					
					if( i==0 || i==2 || i==6 || i==8 ) {
						repeat = false;
					}
					
					tile.graphics.beginBitmapFill( _tilesBd[id], matrix, repeat, _isSmoothing );
					tile.graphics.drawRect( 0, 0, _parts[i].width - uint(_isShowGrid ), _parts[i].height - uint(_isShowGrid ) );
					
					tile.graphics.endFill();
					
					tile.x = _parts[i].x;
					tile.y = _parts[i].y;
					
					super.addChild( tile );
					id += uint( (id + 1 ) < _tilesBd.length );
				}
			}
			tile = null;
			matrix = null;
		}
		
		private function removeTiles():void {
			while( numChildren ) {
				removeChildAt( 0 );
			}
		}
		
		/**************************************************************************
		 * Handlers
		 **************************************************************************/
		
		/**************************************************************************
		 * Gets/Sets
		 **************************************************************************/
		override public function set width( value:Number ):void {
			_width = Math.max( _parts[0].width + _parts[8].width + 1, value );
			_parts[1].width = _parts[4].width = _parts[7].width = _width - _parts[0].width - _parts[8].width;
			_parts[2].x = _parts[5].x = _parts[8].x = _width - _parts[8].width;
			
			build();
		}
		override public function set height( value:Number ):void {
			_height = Math.max( _parts[0].height + _parts[8].height + 1, value );
			_parts[3].height = _parts[4].height = _parts[5].height = _height - _parts[0].height - _parts[8].height;
			_parts[6].y = _parts[7].y = _parts[8].y = _height - _parts[8].height;
			
			build();
		}
		
		override public function get width():Number {
			return _width;
		}
		override public function get height():Number {
			return _height;
		}
		
		public function get centerPart():Rectangle {
			return _parts[4];
		}
		
		override public function setSize( width:Number, height:Number, rounded:Boolean = true ):void {
			_width = Math.max( _parts[0].width + _parts[8].width + 1, width );
			_width = rounded ? Math.round( _width ) : _width;
			_parts[1].width = _parts[4].width = _parts[7].width = _width - _parts[0].width - _parts[8].width;
			_parts[2].x = _parts[5].x = _parts[8].x = _width - _parts[8].width;
			
			_height = Math.max( _parts[0].height + _parts[8].height + 1, height );
			_height = rounded ? Math.round( _height ) : _height;
			_parts[3].height = _parts[4].height = _parts[5].height = _height - _parts[0].height - _parts[8].height;
			_parts[6].y = _parts[7].y = _parts[8].y = _height - _parts[8].height;
			
			build();
		}
		
		/**************************************************************************
		 * Destructor
		 **************************************************************************/
		override public function kill():void {
			removeTiles();
			
			super.kill();
			
			_bitmapData.dispose();
			_bitmapData = null;
			
			_parts = null;
			_tilesBd = null;
			_leftTop = null;
			_rightBottom = null;
		}
	}

}