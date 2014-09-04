package ru.arslanov.flash.text {
	import flash.events.FocusEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AInputField extends ATextField {
		
		private var _textHelp:*;
		private var _fmt:TextFormat;
		private var _fmtHelp:TextFormat;
		
		private var _width:uint;
		private var _height:uint;
		private var _text:*;
		
		public function AInputField( text:* = "", width:uint = 100, height:int = -1, format:TextFormat = null ) {
			_fmt = format;
			_width = width;
			_height = height;
			_text = text;
			
			super( text, _fmt );
		}
		
		override public function init():* {
			super.init();
			
			if ( !_fmt ) {
				_fmt = super.defaultTextFormat;
			}
			
			text = " ";
			width = _width;
			
			if ( _height == -1 ) {
				super.autoSize = TextFieldAutoSize.LEFT;
			}
			
			super.type = TextFieldType.INPUT;
			super.selectable = true;
			super.autoSize = TextFieldAutoSize.NONE;
			
			text = _text;
			
			return this;
		}
		
		public function setTextHelp( textHelp:* = "", formatHelp:TextFormat = null ):void {
			_textHelp = textHelp;
			_fmtHelp = formatHelp ? formatHelp : super.defaultTextFormat;
			//super.defaultTextFormat = _fmtHelp;
			
			if ( _textHelp != "" ) {
				text = _textHelp;
			}
			
			super.setTextFormat( _fmtHelp );
			
			eventManager.addEventListener( FocusEvent.FOCUS_IN, onFocusIn );
			eventManager.addEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
		}
		
		private function onFocusIn( ev:FocusEvent ):void {
			if ( super.text == _textHelp ) {
				super.defaultTextFormat = _fmt;
				super.text = "";
			}
		}
		
		private function onFocusOut( ev:FocusEvent ):void {
			if ( super.text == "" ) {
				super.defaultTextFormat = _fmtHelp;
				super.text = _textHelp;
			}
		}
		
		override public function get text():String {
			return super.text == _textHelp ? "" : super.text;
		}
		
		override public function set text( value:String ):void {
			if ( super.defaultTextFormat != _fmt ) {
				super.defaultTextFormat = _fmt;
			}
			super.text = value;
		}
		
		public function get textHelp():String {
			return _textHelp;
		}
		
		public function set textHelp( value:String ):void {
			_textHelp = value;
		}
		
		public function clear():void {
			super.defaultTextFormat = _fmtHelp;
			super.text = _textHelp;
		}
		
		override public function kill():void {
			super.kill();
			
			_fmt = null;
			_fmtHelp = null;
		}
	}

}