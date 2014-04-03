package display.gui {
	import data.MoTimeline;
	import display.components.ZoomSlider;
	import display.components.ZoomStep;
	import events.TimelineEvent;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.layout.VBox;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class NavigationBar extends VBox {
		private var _zoSlider:ZoomSlider;
		private var _zoStep:ZoomStep;
		
		public function NavigationBar() {
			super();
		}
		
		override public function init():* {
			_zoSlider = new ZoomSlider().init();
			_zoStep = new ZoomStep().init();
			
			_zoSlider.onChange = onChangeBySlide;
			_zoStep.onChange = onChangeByStep;
			
			addChildAndUpdate( _zoSlider );
			addChildAndUpdate( _zoStep );
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.TIMELINE_RESIZE, onTimelineResize );
			
			onTimelineResize();
			
			_zoSlider.position = 0;
			_zoStep.position = 0;
			
			return super.init();
		}
		
		private function onChangeBySlide():void {
			_zoStep.position = _zoSlider.position;
		}
		
		private function onChangeByStep():void {
			_zoSlider.position = _zoStep.position;
		}
		
		private function onTimelineResize( ev:TimelineEvent = null ):void {
			_zoStep.step = _zoSlider.heightTrack / MoTimeline.me.duration;
			//_zoSlider.position = _zoSlider.heightTrack / MoTimeline.me.duration;
		}
	}

}