package ru.arslanov.flash.text {
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.core.events.EventManager;
	import ru.arslanov.flash.interfaces.IKillableInteractive;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ATextField extends TextField implements IKillableInteractive {
		
		static public var antiAliasTypeDefault	:String = AntiAliasType.ADVANCED;
		static public var autoSizeDefault		:String = TextFieldAutoSize.LEFT;
		static public var borderDefault			:Boolean = false;
		static public var embedFontsDefault		:Boolean = false;
		static public var gridFitTypeDefault	:String = GridFitType.SUBPIXEL;
		static public var textFormatDefault		:TextFormat = new TextFormat( "Arial", 12, 0x0 );
		
		static private var _counter:Number = 0;
		
		public var customData:Object; // Для хранения пользовательских данных
		
		private var _uid:Number = 0;
		private var _isKilled:Boolean;
		private var _isInited:Boolean;
		private var _eventManager:EventManager;
		private var _format:TextFormat;
		private var _text:*;
		
		public function ATextField( text:* = "", format:TextFormat = null ) {
			_uid = ++_counter;
			
			_text = text;
			_format = format;
			
			super();
		}
		
		/**
		 * Метод инициализации экземпляра. Вызывать перед addChild
		 * @return ссылка на себя
		 */
		public function init():* {
			super.embedFonts = embedFontsDefault;
			super.antiAliasType = antiAliasTypeDefault;
			super.gridFitType = gridFitTypeDefault;
			
			super.autoSize = autoSizeDefault;
			super.wordWrap = false;
			super.selectable = false;
			super.multiline = false;
			super.border = borderDefault;
			
			super.defaultTextFormat = _format ? _format : textFormatDefault;
			
			super.text = _text;
			
			_isInited = true;
			
			// override me
			return this;
		}
		
		public function get isInited():Boolean {
			return _isInited;
		}
		
		override public function set defaultTextFormat( value:TextFormat ):void {
			super.defaultTextFormat = value;
			super.text = text;
		}
		
		public function setColorFragment( color:uint, startIndex:uint = 0, length:int = -1 ):void {
			var fmt:TextFormat = this.defaultTextFormat;
			fmt.color = color;
			
			this.defaultTextFormat = fmt;
			this.setTextFormat( fmt, startIndex < text.length ? startIndex : text.length - 1, startIndex + ( length < 0 ? text.length - startIndex : length ) );
		}
		
		public function setWidth( width:Number, wordWrap:Boolean = true, multiline:Boolean = true ):void {
			this.width = width;
			this.wordWrap = wordWrap;
			this.multiline = multiline;
		}
		
		public function setBorder( enable:Boolean, color:uint = 0x0 ):void {
			border = enable;
			borderColor = color;
		}
		
		public function setBackground( enable:Boolean, color:uint = 0x0 ):void {
			background = enable;
			backgroundColor = color;
		}
		
		/**
		 * Убивает экземпляр
		 */
		public function kill():void {
			if ( _isKilled ) throw new Error( this + " ALREADY KILLED!" ).getStackTrace();
			
			if ( _eventManager ) _eventManager.dispose();
			_eventManager = null;
			
			if ( parent ) parent.removeChild( this );
			
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
			return "0x" + _uid.toString( 16 ).toUpperCase();
		}
		
		override public function toString():String {
			return "[" + getQualifiedClassName( this ).split( ":" ).pop() + " " + uidStr + ", text:'" + text.substr( 0, 20 ) + "']";
		}
		
		public function toStringGeometry():String {
			return toString() + " x:" + x + ", y:" + y + ", width:" + width + ", height:" + height;
		}
		
		/* INTERFACE ru.arslanov.core.interfaces.IInteractiveObjectKillable */
		
		public function get eventManager():EventManager {
			if ( !_eventManager ) _eventManager = new EventManager( this );
			return _eventManager;
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