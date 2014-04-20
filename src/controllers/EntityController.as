package controllers {
	import constants.LocaleString;
	import data.MoEntity;
	import data.MoTimeline;
	import display.base.HintApp;
	import display.objects.Entity;
	import flash.events.MouseEvent;
	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.hints.AHintManager;
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
			
			var textHint:String = ent.moEntity.title
								+ "\r"
								+ JDUtils.getFormatString( ent.moEntity.beginPeriod.beginJD, LocaleString.DATE_ENTITY_HINT )
								+ "\r"
								+ JDUtils.getFormatString( ent.moEntity.endPeriod.endJD, LocaleString.DATE_ENTITY_HINT );
			
			AHintManager.me.displayHint( HintApp, { text: textHint } );
		}
		
		private function hrMouseOut( ev:MouseEvent ):void {
			var ent:Entity = ev.target.parent as Entity;
			if ( !ent ) return;
			
			AHintManager.me.removeHint();
		}
		
		private function hrDoubleClick( ev:MouseEvent ):void {
			var ent:Entity = ev.target.parent as Entity;
			if ( !ent ) return;
			
			if ( ent.moEntity.duration == 0 )
				return;
			
			//MoTimeline.me.setRange( ent.moEntity.beginPeriod.dateBegin.jd, ent.moEntity.endPeriod.dateEnd.jd );
			
			var scale:Number = (Display.stageHeight - Settings.TOOLBAR_HEIGHT) / ent.moEntity.duration;
			
			MoTimeline.me.baseJD = (ent.moEntity.beginPeriod.beginJD + ent.moEntity.endPeriod.endJD) / 2;
			MoTimeline.me.scale = scale;
			//MoTimeline.me.setRange( ent.moEntity.beginPeriod.dateBegin.jd, ent.moEntity.endPeriod.dateEnd.jd );
		}
		
		public function dispose():void {
			_target.eventManager.removeEventListener( MouseEvent.MOUSE_OVER, hrMouseOver );
			_target.eventManager.removeEventListener( MouseEvent.MOUSE_OUT, hrMouseOut );
			_target.eventManager.removeEventListener( MouseEvent.DOUBLE_CLICK, hrDoubleClick );
			
			_target = null;
		}
	}

}