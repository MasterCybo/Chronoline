package display.gui {
	import data.MoTimeline;
	import display.components.DateGraduation;
	import events.TimelineEvent;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GridScale extends ASprite {
		
		private var _pattern:BitmapData;
		
		private var _width:uint;
		private var _height:uint;
		
		public function GridScale( width:uint, height:uint ) {
			_width = width;
			_height = height;
			
			super();
		}
		
		override public function init():* {
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.TIMELINE_RESIZE, onTimelineResize );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onScaleChange );
			
			return super.init();
		}
		
		private function onScaleChange( ev:TimelineEvent ):void {
		
		}
		
		private function onTimelineResize( ev:TimelineEvent ):void {
			Log.traceText( "*execute* GridScale.onTimelineResize" );
			
			draw();
		}
		
		private function update():void {
			//createPattern();
			draw();
		}
		
		private function draw():void {
			var stepTime:Number = MoTimeline.me.duration / 10;
			var stepY:Number = _height / 10;
			
			killChildren();
			
			for ( var i:int = 0; i < 10; i++ ) {
				Log.traceText( i + " add" );
				var dateGrad:DateGraduation = new DateGraduation( MoTimeline.me.beginDate.jd + i * stepTime, _width ).init();
				dateGrad.y = i * stepY;
				addChild( dateGrad );
			}
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width( value:Number ):void {
			_width = value;
			
			draw();
		}
		
		override public function get height():Number {
			return _height;
		}
		
		override public function set height( value:Number ):void {
			_height = value;
			
			draw();
		}
		
	}

}