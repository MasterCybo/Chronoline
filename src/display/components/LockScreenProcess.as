package display.components {
	import constants.LocaleString;
	import constants.TextFormats;

	import display.base.TextApp;

	import events.ProcessUpdateNotice;

	import ru.arslanov.core.events.Notification;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class LockScreenProcess extends ASprite {
		
		private var _bg:ASprite;
		private var _width:uint;
		private var _height:uint;
		private var _tfProgress:TextApp;
		private var _info:ASprite;
		
		public function LockScreenProcess( width:uint, height:uint ) {
			_width = width;
			_height = height;
			super();
		}
		
		override public function init():* {
			super.init();
			
			_bg = new ASprite().init();
			_bg.graphics.beginFill( 0x000000, 0.75 );
			_bg.graphics.drawRect( 0, 0, _width, _height );
			_bg.graphics.endFill();
			
			_info = new ASprite().init();
			
			var tfWaiting:TextApp = new TextApp( LocaleString.WAITING_PROCESS, TextFormats.WHITE_20 ).init();
			_tfProgress = new TextApp( "0%", TextFormats.WHITE_20 ).init();
			_tfProgress.x = int((tfWaiting.width - _tfProgress.width) / 2);
			_tfProgress.y = tfWaiting.height;
			_info.addChild( tfWaiting );
			_info.addChild( _tfProgress );
			
			updateSize();
			
			addChild( _bg );
			addChild( _info );
			
			mouseEnabled = mouseChildren = true;
			
			Notification.add( ProcessUpdateNotice.NAME, onUpdateProcess );
			
			return this;
		}
		
		private function onUpdateProcess( notice:ProcessUpdateNotice ):void {
			_tfProgress.text = int(notice.progress * 100) + "%";
			
			_tfProgress.x = int((_info.width - _tfProgress.width) / 2);
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
			
			_info.x = int((_width - _info.width) / 2);
			_info.y = int((_height - _info.height) / 2);
		}
	}

}