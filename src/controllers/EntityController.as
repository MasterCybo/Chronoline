package controllers {
	import data.MoEntity;
	import data.MoTimeline;
	import display.base.HintApp;
	import flash.events.MouseEvent;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.hints.AHintManager;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntityController {
		
		private var _target:ASprite;
		private var _moEntity:MoEntity;
		
		public function EntityController( target:ASprite, moEntity:MoEntity ) {
			_target = target;
			_moEntity = moEntity;
		}
		
		public function init():void {
			_target.mouseChildren = false;
			_target.doubleClickEnabled = _target.buttonMode = true;
			_target.eventManager.addEventListener( MouseEvent.MOUSE_OVER, hrMouseOver );
			_target.eventManager.addEventListener( MouseEvent.MOUSE_OUT, hrMouseOut );
			_target.eventManager.addEventListener( MouseEvent.DOUBLE_CLICK, hrDoubleClick );
		}
		
		private function hrMouseOver( ev:MouseEvent ):void {
			AHintManager.me.displayHint( HintApp, { text: _moEntity.title } );
		}
		
		private function hrMouseOut( ev:MouseEvent ):void {
			AHintManager.me.removeHint();
		}
		
		private function hrDoubleClick( ev:MouseEvent ):void {
			if ( _moEntity.duration == 0 )
				return;
			
			MoTimeline.me.setRange( _moEntity.beginPeriod.dateBegin.jd, _moEntity.endPeriod.dateEnd.jd );
		}
		
		public function dispose():void {
			_target.eventManager.removeEventListener( MouseEvent.MOUSE_OVER, hrMouseOver );
			_target.eventManager.removeEventListener( MouseEvent.MOUSE_OUT, hrMouseOut );
			_target.eventManager.removeEventListener( MouseEvent.DOUBLE_CLICK, hrDoubleClick );
			
			_target = null;
			_moEntity = null;
		}
	}

}