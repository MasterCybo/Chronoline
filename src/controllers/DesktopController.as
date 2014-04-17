package controllers {
	import data.MoTimeline;
	import display.base.ButtonApp;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import ru.arslanov.core.controllers.MouseController;
	import ru.arslanov.core.controllers.SimpleDragController;
	import ru.arslanov.core.events.MouseControllerEvent;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DesktopController {
		
		private var _mouseTarget:ASprite;
		private var _mouse:SimpleDragController;
		private var _offset:Number = 0;
		
		public function DesktopController( mouseTarget:ASprite ) {
			_mouseTarget = mouseTarget;
		}
		
		public function init():void {
			//_mouse = new MouseController( _mouseTarget );
			_mouse = new SimpleDragController( Display.stage );
			_mouse.addEventListener( MouseControllerEvent.MOUSE_DOWN, onStageDown );
			_mouse.addEventListener( MouseControllerEvent.MOUSE_UP, onStageUp );
			_mouse.addEventListener( MouseControllerEvent.MOUSE_DRAG, dragDesktop );
			_mouse.addEventListener( MouseControllerEvent.MOUSE_WHEEL, dragDesktop );
		}
		
		private function onStageDown( ev:MouseControllerEvent ):void {
			//_offset = 0;
			
			if ( ev.target is ButtonApp ) return;
			
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function onStageUp( ev:MouseControllerEvent ):void {
			Mouse.cursor = MouseCursor.AUTO;
			
			//if ( ev.target is ButtonApp ) return;
			
			//if ( Math.abs( _offset ) > 10 ) return;
		}
		
		private function dragDesktop( ev:MouseControllerEvent ):void {
			var dy:Number = _mouse.movement.y;
			
			if ( _mouse.deltaWheel != 0 ) {
				dy = 10 * _mouse.deltaWheel; // Если вращаем колесо, тогда берём шаг колеса
			}
			
			var deltaJD:Number = dy / MoTimeline.me.scale;
			
			//_offset += dy;
			
			MoTimeline.me.baseJD -= deltaJD;
		}
		
		public function dispose():void {
			_mouse.dispose();
			
			_mouseTarget = null;
		}
	}

}