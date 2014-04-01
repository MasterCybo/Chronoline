package controllers {
	import data.MoEntity;
	import data.MoTimeline;
	import display.base.HintApp;
	import flash.events.MouseEvent;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.hints.AHintManager;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntityController {
		
		private var _target:ASprite;
<<<<<<< HEAD
		
		public function EntityController( target:ASprite ) {
=======
		private var _moEntity:MoEntity;
		
		public function EntityController( target:ASprite, moEntity:MoEntity ) {
>>>>>>> 7765d46036a6e3d94ef8935b22b5158b497180f3
			_target = target;
		}
		
		public function init():void {
<<<<<<< HEAD
=======
			_target.mouseChildren = false;
			_target.doubleClickEnabled = _target.buttonMode = true;
>>>>>>> 7765d46036a6e3d94ef8935b22b5158b497180f3
			_target.eventManager.addEventListener( MouseEvent.MOUSE_OVER, hrMouseOver );
			_target.eventManager.addEventListener( MouseEvent.MOUSE_OUT, hrMouseOut );
			_target.eventManager.addEventListener( MouseEvent.DOUBLE_CLICK, hrDoubleClick );
		}
		
		private function hrMouseOver( ev:MouseEvent ):void {
<<<<<<< HEAD
			var ent:Entity = ev.target.parent as Entity;
			if ( !ent ) return;
			
			AHintManager.me.displayHint( HintApp, { text: ent.moEntity.title } );
=======
			AHintManager.me.displayHint( HintApp, { text: _moEntity.title } );
>>>>>>> 7765d46036a6e3d94ef8935b22b5158b497180f3
		}
		
		private function hrMouseOut( ev:MouseEvent ):void {
			var ent:Entity = ev.target.parent as Entity;
			if ( !ent ) return;
			
			AHintManager.me.removeHint();
		}
		
		private function hrDoubleClick( ev:MouseEvent ):void {
<<<<<<< HEAD
			var ent:Entity = ev.target.parent as Entity;
			if ( !ent ) return;
			
			if ( ent.moEntity.duration == 0 )
=======
			if ( _moEntity.duration == 0 )
>>>>>>> 7765d46036a6e3d94ef8935b22b5158b497180f3
				return;
			
			MoTimeline.me.setRange( ent.moEntity.beginPeriod.dateBegin.jd, ent.moEntity.endPeriod.dateEnd.jd );
		}
		
		public function dispose():void {
			_target.eventManager.removeEventListener( MouseEvent.MOUSE_OVER, hrMouseOver );
			_target.eventManager.removeEventListener( MouseEvent.MOUSE_OUT, hrMouseOut );
			_target.eventManager.removeEventListener( MouseEvent.DOUBLE_CLICK, hrDoubleClick );
			
			_target = null;
		}
	}

}