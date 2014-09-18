package controllers {
	import data.MoTimeline;

	import display.base.ButtonApp;
	import display.gui.Desktop;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import ru.arslanov.core.controllers.SimpleDragController;
	import ru.arslanov.core.events.MouseControllerEvent;
	import ru.arslanov.core.utils.Calc;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DesktopController {
		
		private var _movement:Point = new Point();
		private var _target:Desktop;

		public function DesktopController( target:Desktop ) {
			_target = target;
		}
		
		public function init():void {
			_target.eventManager.addEventListener(MouseEvent.MOUSE_DOWN, onStageDown);
			_target.eventManager.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMove);
		}

		private function onStageDown( ev:MouseEvent ):void {
			_movement.setTo( ev.stageX, ev.stageY );

			Mouse.cursor = MouseCursor.HAND;

			Display.stageAddEventListener(MouseEvent.MOUSE_MOVE, onStageMove);
			Display.stageAddEventListener(MouseEvent.MOUSE_UP, onStageUp);
		}
		
		private function onStageUp( ev:MouseEvent ):void {
			Display.stageRemoveEventListener(MouseEvent.MOUSE_MOVE, onStageMove);
			Display.stageRemoveEventListener(MouseEvent.MOUSE_UP, onStageUp);

			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function onStageMove( ev:MouseEvent ):void {
			var dx:Number = ev.stageX - _movement.x;
			var dy:Number = ev.stageY - _movement.y;

			if ( ev.delta != 0 ) {
				dy = 10 * ev.delta; // Если вращаем колесо, тогда берём шаг колеса
			}
			
			MoTimeline.me.baseJD = MoTimeline.me.baseJD - dy / MoTimeline.me.scale;

			_movement.offset( dx, dy );
		}
		
		public function dispose():void {
			_target.eventManager.addEventListener(MouseEvent.MOUSE_DOWN, onStageDown);
			_target.eventManager.addEventListener(MouseEvent.MOUSE_WHEEL, onStageMove);
			Display.stageRemoveEventListener(MouseEvent.MOUSE_MOVE, onStageMove);
			Display.stageRemoveEventListener(MouseEvent.MOUSE_UP, onStageUp);

			_target = null;
		}
	}

}