package display.gui {
	import data.MoDate;
	import data.MoTimeline;
	import events.TimelineEvent;
	import flash.display.BitmapData;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class RulerGlobal extends ASprite {
		
		private var _body:ABitmap;
		private var _thumb:ThumbTimeTracker;
		private var _height:Number;
		private var _tlineDateBegin:MoDate;
		private var _tlineDateEnd:MoDate;
		private var _rangeDateBegin:MoDate;
		private var _rangeDateEnd:MoDate;
		private var _duration:Number = 0;
		private var _ruler:GlobalRulerView;
		
		public function RulerGlobal( height:Number = 500 ) {
			_height = height;
			
			super();
		}
		
		override public function init():* {
			_body = ABitmap.fromColor( Settings.TL_BODY_COLOR, Settings.TL_BODY_WIDTH, _height ).init();
			
			_ruler = new GlobalRulerView( Settings.TL_BODY_WIDTH, _height ).init();
			
			_thumb = new ThumbTimeTracker( _height ).init();
			_thumb.onMove = onMoveRangeManual;
			_thumb.onResize = onResizeRangeManual;
			_thumb.onDown = removeTimelineListeners;
			_thumb.onUp = addTimelineListeners;
			
			addChild( _body );
			addChild( _thumb );
			addChild( _ruler );
			
			
			_tlineDateBegin = MoTimeline.me.beginDate;
			_tlineDateEnd = MoTimeline.me.endDate;
			_rangeDateBegin = MoTimeline.me.rangeBegin;
			_rangeDateEnd = MoTimeline.me.rangeEnd;
			
			
			checkDisplayThumb();
			
			addTimelineListeners();
			
			return super.init();
		}
		
		private function onResizeTimeline( ev:TimelineEvent ):void {
			_duration = MoTimeline.me.duration;
			
			//_ruler.redraw();
			
			_thumb.heightMax = _height;
			
			checkDisplayThumb();
		}
		
		private function onResizeRange( ev:TimelineEvent ):void {
			_thumb.setPositions( dateToY( _rangeDateBegin.jd ), dateToY( _rangeDateEnd.jd ) );
		}
		
		private function onMoveRange( ev:TimelineEvent ):void {
			onResizeRange( ev );
		}
		
		private function onMoveRangeManual():void {
			onResizeRangeManual();
		}
		
		private function onResizeRangeManual():void {
			var nb:Number = _tlineDateBegin.jd + _thumb.posTop * _duration;
			var ne:Number = _tlineDateBegin.jd + _thumb.posDown * _duration;
			
			MoTimeline.me.setRange( nb, ne );
		}
		
		public function checkDisplayThumb():void {
			if ( _duration > 0 ) {
				if ( !contains( _thumb ) ) {
					addChild( _thumb );
					swapChildren( _thumb, _ruler );
				}
			} else {
				if ( contains( _thumb ) ) {
					removeChild( _thumb );
				}
			}
		}
		
		/***************************************************************************
		Обработчики 
		***************************************************************************/
		private function removeTimelineListeners():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.TIMELINE_RESIZE, onResizeTimeline );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.RANGE_RESIZE, onResizeRange );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.RANGE_MOVE, onMoveRange );
		}
		
		private function addTimelineListeners():void {
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.TIMELINE_RESIZE, onResizeTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_RESIZE, onResizeRange );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_MOVE, onMoveRange );
		}
		
		private function dateToY( value:Number ):Number {
			return ( value - _tlineDateBegin.jd ) / _duration;
		}
		
		override public function set height( value:Number ):void {
			_height = value;
			
			_body.bitmapData.dispose();
			_body.bitmapData = new BitmapData( Settings.TL_BODY_WIDTH, _height, false, Settings.TL_BODY_COLOR );
			
			//if ( _duration > 0 ) {
				_ruler.height = _height;
				_thumb.heightMax = _height;
			//}
		}
		
		override public function kill():void {
			removeTimelineListeners();
			
			_tlineDateBegin = null;
			_tlineDateEnd = null;
			_rangeDateBegin = null;
			_rangeDateEnd = null;
			
			super.kill();
		}
	}

}