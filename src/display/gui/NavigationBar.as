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
		private var _zoStepper:ZoomStepper;
		private var _minScale:Number;
		private var _maxScale:Number;
		
		public function NavigationBar() {
			super();
		}
		
		override public function init():* {
			_zoSlider = new ZoomSlider().init();
			_zoStepper = new ZoomStepper().init();
			
			_zoSlider.onChange = onSliderChange;
			_zoSlider.onPress = onSliderPress;
			_zoSlider.onRelease = onSliderRelease;
			
			_zoStepper.onChange = onStepperChange;
			
			addChildAndUpdate( _zoSlider );
			addChildAndUpdate( _zoStepper );
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			
			onInitTimeline();
			onSliderRelease();
			
			_zoSlider.position = 0;
			_zoStepper.position = 0;
			
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
			_zoSlider.position = _zoStepper.position = ( MoTimeline.me.scale - _minScale ) / (_maxScale - _minScale);
		}
		
		private function onSliderChange():void {
//			_zoStepper.position = _zoSlider.position;
			
			
			var pos:Number = _zoSlider.position;
			var deltaScale:Number = _maxScale - _minScale;
			var newScale:Number = Math.pow( deltaScale, pos );

			var sc1:Number = _minScale + newScale;
			var sc2:Number = _minScale * newScale;

//			Log.traceText( deltaScale + " ^ " + pos + " = " + newScale );
			Log.traceText( "    " + _minScale + " + " + newScale + " = " + sc1 );
//			Log.traceText( "        " + _minScale + " * " + newScale  + " = " + sc2 );

			MoTimeline.me.scale = sc1;
			
//			MoTimeline.me.scale = _minScale + _zoSlider.position * (_maxScale - _minScale);
			//Log.traceText( "_zoSlider.position : " + _zoSlider.position );
			//Log.traceText( "MoTimeline.me.scale : " + MoTimeline.me.scale );
		}
		
		private function onStepperChange():void {
//			_zoSlider.position = _zoStepper.position;

			var pos:Number = _zoStepper.position;
			var deltaScale:Number = _maxScale - _minScale;
			var newScale:Number = Math.pow( deltaScale, pos );
			
			var sc1:Number = _minScale + newScale;
			var sc2:Number = _minScale * newScale;
			
			Log.traceText( deltaScale + " ^ " + pos + " = " + newScale );
//			Log.traceText( "    " + _minScale + " + " + newScale + " = " + sc1 );
//			Log.traceText( "        " + _minScale + " * " + newScale  + " = " + sc2 );
			
//			MoTimeline.me.scale = _minScale + _zoStepper.position * (_maxScale - _minScale);
			MoTimeline.me.scale = sc1;
		}
		
		private function onInitTimeline( ev:TimelineEvent = null ):void {
			//Log.traceText( "*execute* NavigationBar.onInitTimeline" );
			
			_minScale = (Display.stageHeight - Settings.TOOLBAR_HEIGHT) / MoTimeline.me.duration;
			_maxScale = MoTimeline.me.duration / (Display.stageHeight - Settings.TOOLBAR_HEIGHT);
			
			//Log.traceText( "_minScale : " + _minScale );
			//Log.traceText( "_maxScale : " + _maxScale );

//			_zoStepper.step = 1 / MoTimeline.me.duration;
			
			//_zoStepper.step = _zoSlider.heightTrack / MoTimeline.me.duration;
			//Log.traceText( "_zoStepper.step : " + _zoStepper.step );
			//_zoSlider.position = _zoSlider.heightTrack / MoTimeline.me.duration;
		}
		
		override public function kill():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onTimelineRescale );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );
			
			super.kill();
		}
	}

}