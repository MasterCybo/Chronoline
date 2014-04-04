package display.gui {
	import data.MoTimeline;
	import display.components.ZoomSlider;
	import display.components.ZoomStepper;
	import events.TimelineEvent;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.gui.layout.VBox;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class NavigationBar extends VBox {
		private var _zoSlider:ZoomSlider;
		private var _zoStep:ZoomStepper;
		private var _minScale:Number;
		private var _maxScale:Number;
		
		public function NavigationBar() {
			super();
		}
		
		override public function init():* {
			_zoSlider = new ZoomSlider().init();
			_zoStep = new ZoomStepper().init();
			
			_zoSlider.onChange = onSliderChange;
			_zoStep.onChange = onStepperChange;
			
			addChildAndUpdate( _zoSlider );
			addChildAndUpdate( _zoStep );
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.TIMELINE_RESIZE, onTimelineResize );
			
			onTimelineResize();
			
			_zoSlider.position = 0;
			_zoStep.position = 0;
			
			return super.init();
		}
		
		private function onSliderChange():void {
			_zoStep.position = _zoSlider.position;
			
			//Log.traceText( "_zoSlider.position : " + _zoSlider.position );
			
			MoTimeline.me.scale = _minScale + _zoSlider.position * (_maxScale - _minScale);
		}
		
		private function onStepperChange():void {
			_zoSlider.position = _zoStep.position;
			
			MoTimeline.me.scale = _minScale + _zoStep.position * (_maxScale - _minScale);
		}
		
		private function onTimelineResize( ev:TimelineEvent = null ):void {
			Log.traceText( "*execute* NavigationBar.onTimelineResize" );
			
			_minScale = (Display.stageHeight - Settings.TOOLBAR_HEIGHT) / MoTimeline.me.duration;
			_maxScale = MoTimeline.me.duration / (Display.stageHeight - Settings.TOOLBAR_HEIGHT);
			
			Log.traceText( "_minScale : " + _minScale );
			Log.traceText( "_maxScale : " + _maxScale );
			
			_zoStep.step = _zoSlider.heightTrack / MoTimeline.me.duration;
			//_zoSlider.position = _zoSlider.heightTrack / MoTimeline.me.duration;
		}
	}

}