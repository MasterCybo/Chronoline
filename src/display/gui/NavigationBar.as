package display.gui {
	import data.MoTimeline;

	import display.components.ZoomSlider;
	import display.components.ZoomStepper;

	import events.TimelineEvent;

	import ru.arslanov.core.utils.Calc;

	import ru.arslanov.core.utils.JDUtils;

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
		private var _isManual:Boolean;
		
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
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onTimelineRescale );
			
			onInitTimeline();
			onSliderRelease();
			
			_zoSlider.position = 0;
			_zoStepper.position = 0;
			
			return super.init();
		}

		private function onInitTimeline( ev:TimelineEvent = null ):void {
			_minScale = (Display.stageHeight - Settings.TOOLBAR_HEIGHT) / MoTimeline.me.duration;
//			_maxScale = MoTimeline.me.duration / (Display.stageHeight - Settings.TOOLBAR_HEIGHT);
//			Log.traceText( "1 _maxScale : " + _maxScale );
			_maxScale = JDUtils.DAYS_PER_YEAR; // Максимальное увеличение: 1 день = высоте экрана
//			Log.traceText( "2 _maxScale : " + _maxScale );

			_zoStepper.step = (_maxScale - _minScale) / (100 * _zoSlider.heightTrack);
		}

		private function onSliderPress():void {
//			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onTimelineRescale );
		}

		private function onSliderRelease():void {
//			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onTimelineRescale );
		}

		private function onTimelineRescale( ev:TimelineEvent ):void {
			if ( _isManual ) {
				_isManual = false;
				return;
			}

			var lnds:Number = Calc.ln(_maxScale - _minScale);

			_zoSlider.position = _zoStepper.position = ( MoTimeline.me.scale - _minScale ) * lnds / lnds;

			_isManual = false;
		}

		private function onSliderChange():void {
			_isManual = true;

			_zoStepper.position = _zoSlider.position;

			updateScale( _zoSlider.position );
		}

		private function onStepperChange():void {
			_isManual = true;

			_zoSlider.position = _zoStepper.position;

			updateScale( _zoStepper.position );
		}

		private function updateScale( position:Number ):void
		{
			var deltaScale:Number = _maxScale - _minScale;
			var expScale:Number = Math.pow( deltaScale, position );

			MoTimeline.me.scale = _minScale + position * expScale;
		}

		override public function kill():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onTimelineRescale );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );

			super.kill();
		}
	}

}