package controllers {
	import constants.LocaleString;

	import data.MoTimeline;

	import display.base.TooltipApp;
	import display.gui.EntityTooltip;
	import display.objects.Entity;

	import flash.events.MouseEvent;

	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.hints.ATooltipManager;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntityController {
		
		private var _target:ASprite;
		
		public function EntityController( target:ASprite ) {
			_target = target;
		}
		
		public function init():void {
			_target.eventManager.addEventListener( MouseEvent.MOUSE_OVER, hrMouseOver );
			_target.eventManager.addEventListener( MouseEvent.MOUSE_OUT, hrMouseOut );
			_target.eventManager.addEventListener( MouseEvent.DOUBLE_CLICK, hrDoubleClick );
		}
		
		private function hrMouseOver( ev:MouseEvent ):void {
			var ent:Entity = ev.target.parent as Entity;
			if ( !ent ) return;
			
			ATooltipManager.me.displayHint( EntityTooltip, ent.moEntity );
		}
		
		private function hrMouseOut( ev:MouseEvent ):void {
			var ent:Entity = ev.target.parent as Entity;
			if ( !ent ) return;
			
			ATooltipManager.me.removeHint();
		}

		/**
		 * Двойной клик по сущности, отображает её во всю высоту экрана, изменяя масштаб и базовую дату.
		 * @param ev
		 */
		private function hrDoubleClick( ev:MouseEvent ):void {
			var ent:Entity = ev.target.parent as Entity;
			if ( !ent ) return;
			
			if ( ent.moEntity.duration == 0 ) return;
			
			var scale:Number = (Display.stageHeight - Settings.TOOLBAR_HEIGHT) / ent.moEntity.duration;
			
			MoTimeline.me.baseJD = ( ent.moEntity.beginPeriod.beginJD + ent.moEntity.endPeriod.endJD ) / 2;
			MoTimeline.me.scale = scale;
		}
		
		public function dispose():void {
			_target.eventManager.removeEventListener( MouseEvent.MOUSE_OVER, hrMouseOver );
			_target.eventManager.removeEventListener( MouseEvent.MOUSE_OUT, hrMouseOut );
			_target.eventManager.removeEventListener( MouseEvent.DOUBLE_CLICK, hrDoubleClick );
			
			_target = null;
		}
	}

}