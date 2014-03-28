package display.components {
	import constants.LocaleString;
	import constants.TextFormats;
	import display.base.ButtonApp;
	import display.base.TextApp;
	import display.gui.buttons.ButtonText;
	import events.ProcessUpdateNotice;
	import flash.display.BitmapData;
	import ru.arslanov.core.events.Notification;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MessageFullScreen extends ASprite {
		
		private var _bg:ASprite;
		private var _width:uint;
		private var _height:uint;
		private var _boxCenter:ASprite;
		private var _message:String;
		private var _callbackClick:Function;
		
		public function MessageFullScreen( width:uint, height:uint, message:String = "", onClickButton:Function = null ) {
			_width = width;
			_height = height;
			_message = message;
			_callbackClick = onClickButton;
			super();
		}
		
		override public function init():* {
			super.init();
			
			_bg = new ASprite().init();
			_bg.graphics.beginFill( 0x000000, 0.75 );
			_bg.graphics.drawRect( 0, 0, _width, _height );
			_bg.graphics.endFill();
			
			_boxCenter = new ASprite().init();
			
			var tfMessage:TextApp = new TextApp( _message, TextFormats.WHITE_20 ).init();
			_boxCenter.addChild( tfMessage );
			
			var btnClose:ButtonText = new ButtonText( LocaleString.NEXT ).init();
			btnClose.onRelease = _callbackClick;
			btnClose.x = tfMessage.x + int((tfMessage.width - btnClose.width) / 2);
			btnClose.y = tfMessage.y + tfMessage.height + 10;
			_boxCenter.addChild( btnClose );
			
			updateSize();
			
			addChild( _bg );
			addChild( _boxCenter );
			
			mouseEnabled = mouseChildren = true;
			
			return this;
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width(value:Number):void {
			_width = value;
			
			updateSize();
		}
		
		override public function get height():Number {
			return _height;
		}
		
		override public function set height(value:Number):void {
			_height = value;
			
			updateSize();
		}
		
		private function updateSize():void {
			_bg.width = _width;
			_bg.height = _height;
			
			_boxCenter.x = int((_width - _boxCenter.width) / 2);
			_boxCenter.y = int((_height - _boxCenter.height) / 2);
		}
		
		override public function kill():void {
			_callbackClick = null;
			
			super.kill();
		}
	}

}