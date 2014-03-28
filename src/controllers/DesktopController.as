package controllers {
	import data.MoTimeline;
	import display.base.ButtonApp;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import ru.arslanov.core.controllers.MouseController;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DesktopController {
		
		private var _mouseTarget:ASprite;
		private var _mouse:MouseController;
		private var _offset:Number = 0;
		
		public function DesktopController( mouseTarget:ASprite ) {
			_mouseTarget = mouseTarget;
		}
		
		public function init():void {
			_mouse = new MouseController( _mouseTarget );
			_mouse.handlerDown = onStageDown;
			_mouse.handlerUp = onStageUp;
			_mouse.handlerDrag = onDragMouse;
			_mouse.handlerWheel = onDragMouse;
		}
		
		private function onStageDown( ev:MouseEvent ):void {
			_offset = 0;
			
			if ( ev.target is ButtonApp ) return;
			
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function onStageUp( ev:MouseEvent ):void {
			Mouse.cursor = MouseCursor.AUTO;
			
			if ( ev.target is ButtonApp ) return;
			
			if ( Math.abs( _offset ) > 10 ) return;
		}
		
		private function onDragMouse( ev:MouseEvent ):void {
			var delta:Number = 0;
			
			if ( ev.delta != 0 ) {
				delta = 10 * ev.delta; // Если зафиксировали вращение колеса
			} else {
				delta = _mouse.movement.y; // Если мышой драгаем
			}
			
			var rDur:Number = MoTimeline.me.rangeEnd.jd - MoTimeline.me.rangeBegin.jd;
			
			var dy:Number = delta * ( rDur / _mouseTarget.height );
			
			_offset += delta;
			
			var nbJD:Number = MoTimeline.me.rangeBegin.jd - dy;
			var neJD:Number = MoTimeline.me.rangeEnd.jd - dy;
			
			if ( nbJD < MoTimeline.me.beginDate.jd ) return;
			if ( neJD > MoTimeline.me.endDate.jd ) return;
			
			MoTimeline.me.setRange( nbJD, neJD );
		}
		
		public function dispose():void {
			_mouse.dispose();
			
			_mouseTarget = null;
		}
	}

}