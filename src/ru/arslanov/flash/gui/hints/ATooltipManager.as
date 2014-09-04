package ru.arslanov.flash.gui.hints {
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.utils.Display;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ATooltipManager {
		
		/***************************************************************************
		Инициализация синглтона
		***************************************************************************/
		private static var _instance:ATooltipManager;
		
		public static function get me():ATooltipManager {
			if ( _instance == null ) {
				_instance = new ATooltipManager( new PrivateKey() );
			}
			return _instance;
		}
		
		public function ATooltipManager( key:PrivateKey ):void {
			if ( !key ) {
				throw new Error( "Error: Instantiation failed: Use ATooltipManager.instance instead of new." );
			}
		}
		
		/***************************************************************************
		Тело класса
		***************************************************************************/
		public var offsetX:int = 0;
		public var offsetY:int = 0;
		
		private var _container:DisplayObjectContainer;
		private var _hint:ATooltip;
		
		public function init( container:DisplayObjectContainer, offsetX:int = 5, offsetY:int = 5 ):void {
			_container = container;
			this.offsetX = offsetX;
			this.offsetY = offsetY;
		}
		
		public function displayHint( hintClass:Class, data:Object = null ):void {
			removeHint();
			
			_hint = new hintClass( data ).init();
			
			updatePosition();
			
			_container.addChild( _hint );
			
			Display.stageAddEventListener( MouseEvent.MOUSE_MOVE, hrMouseMove );
		}
		
		private function hrMouseMove( ev:MouseEvent ):void {
			updatePosition();
		}
		
		public function removeHint():void {
			if ( !_hint ) return;
			
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, hrMouseMove );
			
			_hint.kill();
			_hint = null;
		}
		
		private function updatePosition():void {
			var xp:Number = Display.mouseX + offsetX;
			var yp:Number = Display.mouseY - offsetY;
			
			if ( xp + _hint.width > Display.stageWidth ) {
				xp = Display.mouseX - offsetX - _hint.width;
			}
			
			if ( yp - _hint.height < 0 ) {
				yp = Display.mouseY + offsetY + _hint.height;
			}
			
			_hint.x = xp;
			_hint.y = yp - _hint.height;
		}
		
		public function get currentHint():ATooltip {
			return _hint;
		}
	}

}

// Приватный ключ для инстанцирования синглтона
internal class PrivateKey{}