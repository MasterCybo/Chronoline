package display.gui {
	import com.greensock.TweenLite;
	import display.base.ButtonApp;
	import display.components.DisplayMenuSettings;
	import display.gui.buttons.TogglerSidebar;
	import events.ServerDataCompleteNotice;
	import flash.display.BitmapData;
	import ru.arslanov.core.events.Notification;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SideBar extends ASprite {
		private var _body:ABitmap;
		private var _btn:TogglerSidebar;
		
		private var _width:uint;
		private var _height:uint;
		
		private var _xOpen:int;
		private var _xClose:int;
		
		private var _isOpened:Boolean = false;
		private var _displaySets:DisplayMenuSettings;
		
		public function SideBar( width:uint, height:uint ) {
			_width = width;
			_height = height;
			
			super();
		}
		
		override public function init():* {
			_btn = new TogglerSidebar().init();
			_btn.x = -_btn.width;
			_btn.onRelease = hrClickButton;
			
			_body = new ABitmap().init();
			
			_displaySets = new DisplayMenuSettings( _width, _height ).init();
			//_displaySets.x = _body.x + 10;
			//_displaySets.y = 10;
			
			updateSize();
			
			addChild( _body );
			addChild( _btn );
			addChild( _displaySets );
			
			Notification.add( ServerDataCompleteNotice.NAME, onCloseSideBar );
			
			return super.init();
		}
		
		private function onCloseSideBar():void {
			_btn.checked = false;
			
			tweenClose();
		}
		
		private function hrClickButton():void {
			if ( _isOpened ) {
				tweenClose();
			} else {
				tweenOpen();
			}
		}
		
		private function tweenOpen():void {
			if ( !contains( _displaySets ) ) {
				addChild( _displaySets );
			};
			TweenLite.to( this, 0.3, { x:Display.stageWidth - _body.width } ); // Открываем панель
			_isOpened = true;
		}
		
		private function tweenClose():void {
			TweenLite.to( this, 0.3, { x:Display.stageWidth, onComplete:hrCompleteClose } ); // Сворачиваем панель
			_isOpened = false;
		}
		
		private function hrCompleteClose():void {
			if ( !contains( _displaySets ) ) return;
			removeChild( _displaySets );
		}
		
		public function get isOpened():Boolean {
			return _isOpened;
		}
		
		public function get widthBody():uint {
			return _body.width;
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width( value:Number ):void {
			_width = value;
			
			updateSize();
		}
		
		override public function get height():Number {
			return _height;
		}
		
		override public function set height( value:Number ):void {
			_height = value;
			
			updateSize();
		}
		
		private function updateSize():void {
			_displaySets.x = 10;
			_displaySets.width = width - 2 * _displaySets.x;
			_displaySets.height = height;
			
			if ( _body.bitmapData ) {
				_body.bitmapData.dispose();
			}
			
			_body.bitmapData = new BitmapData( width - _btn.width, height, false, Settings.SIDEBAR_COLOR );
		}
	}

}
