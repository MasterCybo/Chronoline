package display.components {
	import constants.TextFormats;
	import data.MoTimeline;
	import display.base.InputApp;
	import display.base.TextApp;
	import events.TimelineEvent;
	import flash.events.KeyboardEvent;
	import ru.arslanov.core.utils.DateUtils;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class RangeEditor extends ASprite {
		private var _tfBegin:InputApp;
		private var _tfEnd:InputApp;
		
		public function RangeEditor() {
			super();
		}
		
		override public function init():* {
			_tfBegin = new InputApp( 0, TextFormats.RANGE_EDIT, 75 ).init();
			_tfBegin.setBorder( true, 0xB9B9B9 );
			_tfBegin.setBackground( true, 0xffffff );
			_tfBegin.restrict = "0123456789";
			_tfBegin.maxChars = 4;
			
			var tfHyphen:TextApp = new TextApp( "‒", TextFormats.RANGE_EDIT ).init();
			tfHyphen.x = _tfBegin.x + _tfBegin.width + 5;
			tfHyphen.y = _tfBegin.y;
			
			_tfEnd = new InputApp( 0, TextFormats.RANGE_EDIT, _tfBegin.width ).init();
			_tfEnd.setBorder( _tfBegin.border, _tfBegin.borderColor );
			_tfEnd.setBackground( _tfBegin.background, _tfBegin.backgroundColor );
			_tfEnd.restrict = _tfBegin.restrict;
			_tfEnd.maxChars = _tfBegin.maxChars;
			_tfEnd.x = tfHyphen.x + tfHyphen.width + 5;
			_tfEnd.y = _tfBegin.y;
			
			
			addChild( _tfBegin );
			addChild( tfHyphen );
			addChild( _tfEnd );
			
			
			_tfBegin.eventManager.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			_tfEnd.eventManager.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_RESIZE, onChangedRange );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_MOVE, onChangedRange );
			
			return super.init();
		}
		
		private function onChangedRange( ev:TimelineEvent ):void {
			update();
		}
		
		private function onKeyUp( ev:KeyboardEvent ):void {
			if ( ev.keyCode != 13 ) return; // По Enter-у обновляем линейку
			
			var yb:Number = Number( _tfBegin.text );
			var ye:Number = Number( _tfEnd.text );
			
			if ( ye < yb ) {
				update();
				return;
			}
			
			var gBegin:Object = MoTimeline.me.rangeBegin.getGregorian();
			var gEnd:Object = MoTimeline.me.rangeEnd.getGregorian();
			
			if ( ( yb == gBegin.year ) && ( ye == gEnd.year ) ) return;
			
			var jdb:Number = DateUtils.dateToJDN( yb, gBegin.month, gBegin.date )
			var jde:Number = DateUtils.dateToJDN( ye, gEnd.month, gEnd.date )
			
			MoTimeline.me.setRange( jdb, jde );
		}
		
		private function update():void {
			var gBegin:Object = MoTimeline.me.rangeBegin.getGregorian();
			var gEnd:Object = MoTimeline.me.rangeEnd.getGregorian();
			
			_tfBegin.text = String( gBegin.year );
			_tfEnd.text = String( gEnd.year );
		}
		
		override public function kill():void {
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_RESIZE, onChangedRange );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_MOVE, onChangedRange );
			
			super.kill();
		}
		
	}

}