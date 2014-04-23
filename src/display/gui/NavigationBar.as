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
			_zoSlider.onPress = onSliderPress;
			_zoSlider.onRelease = onSliderRelease;
			
			_zoStep.onChange = onStepperChange;
			
			addChildAndUpdate( _zoSlider );
			addChildAndUpdate( _zoStep );
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			
			onInitTimeline();
			onSliderRelease();
			
			_zoSlider.position = 0;
			_zoStep.position = 0;
			
			return super.init();
		}
		
		private function onSliderPress():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onTimelineRescale );
		}
		
		private function onSliderRelease():void {
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onTimelineRescale );
		}
		
		private function onTimelineRescale( ev:TimelineEvent ):void {
			Log.traceText( "*execute* NavigationBar.onTimelineRescale" );
			_zoSlider.position = _zoStep.position = ( MoTimeline.me.scale - _minScale ) / (_maxScale - _minScale);
		}
		
		private function onSliderChange():void {
			_zoStep.position = _zoSlider.position;
			
			//Log.traceText( "_zoSlider.position : " + _zoSlider.position );
			
			MoTimeline.me.scale = _minScale + _zoSlider.position * (_maxScale - _minScale);
			//Log.traceText( "_zoSlider.position : " + _zoSlider.position );
			//Log.traceText( "MoTimeline.me.scale : " + MoTimeline.me.scale );
		}
		
		private function onStepperChange():void {
			_zoSlider.position = _zoStep.position;
			
			MoTimeline.me.scale = _minScale + _zoStep.position * (_maxScale - _minScale);
		}
		
		private function onInitTimeline( ev:TimelineEvent = null ):void {
			//Log.traceText( "*execute* NavigationBar.onInitTimeline" );
			
			_minScale = (Display.stageHeight - Settings.TOOLBAR_HEIGHT) / MoTimeline.me.duration;
			_maxScale = MoTimeline.me.duration / (Display.stageHeight - Settings.TOOLBAR_HEIGHT);
			
			//Log.traceText( "_minScale : " + _minScale );
			//Log.traceText( "_maxScale : " + _maxScale );
			
			//_zoStep.step = _zoSlider.heightTrack / MoTimeline.me.duration;
			_zoStep.step = 1 / MoTimeline.me.duration;
			//Log.traceText( "_zoStep.step : " + _zoStep.step );
			//_zoSlider.position = _zoSlider.heightTrack / MoTimeline.me.duration;
		}
		
		override public function kill():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onTimelineRescale );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );
			
			super.kill();
		}
	}

}