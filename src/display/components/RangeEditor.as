package display.components {
	import constants.TextFormats;
	import data.MoTimeline;
	import display.base.InputApp;
	import events.TimelineEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class RangeEditor extends ASprite {
		private var _inpDate:InputApp;
		
		public function RangeEditor() {
			super();
		}
		
		override public function init():* {
			_inpDate = new InputApp( 0, TextFormats.RANGE_EDIT, 75 ).init();
			_inpDate.setBorder( true, 0xB9B9B9 );
			_inpDate.setBackground( true, 0xffffff );
			_inpDate.restrict = "0123456789";
			_inpDate.maxChars = 4;
			
			addChild( _inpDate );
			
			_inpDate.eventManager.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitedTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onDateChanged );
			
			return super.init();
		}
		
		private function onInitedTimeline( ev:TimelineEvent ):void {
			update();
		}
		
		private function onDateChanged( ev:TimelineEvent ):void {
			update();
		}
		
		private function onKeyUp( ev:KeyboardEvent ):void {
			if ( ev.keyCode != 13 ) return; // По Enter-у обновляем линейку
			
			var year:Number = Number( _inpDate.text );
			
			var jd:Number = JDUtils.dateToJD( year );
			
			MoTimeline.me.baseJD = jd;
		}
		
		private function update():void {
			var date:Object = JDUtils.JDToDate( MoTimeline.me.baseJD );
			
			_inpDate.text = String( date.year );
		}
		
		override public function kill():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onDateChanged );
			
			super.kill();
		}
		
	}

}