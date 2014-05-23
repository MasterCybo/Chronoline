/**
 * Created by Artem on 21.05.2014.
 */
package display.gui
{
	import data.MoTimeline;

	import display.components.TimelineMiniMap;

	import display.gui.buttons.SBDateThumb;

	import display.skins.ScrollbarBody;

	import events.TimelineEvent;

	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.AScrollBar;
	import ru.arslanov.flash.gui.events.ASliderEvent;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DateScrollBar extends AScrollBar
	{

		private var _isMouse:Boolean = false;
		private var _width:Number;

		public function DateScrollBar( width:Number,  height:Number )
		{
			_width = width;

			super( height );
		}

		override public function init():*
		{
			super.wheelSteps = 100;
			super.overhang = 0.2 * super.size * 0.5;
//			super.setBody( new ScrollbarBody( 20, super.size ).init() );
			super.setBody( new TimelineMiniMap( _width, super.size ).init() );
			super.setThumb( new SBDateThumb( _width, 20 ).init() );
			super.setThumbAutoSize( false, 0.2 * super.size );

			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onScaleTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onBaseChange );

			return super.init();
		}

		private function onBaseChange( event:TimelineEvent ):void
		{
			if ( _isMouse ) return;

			super.position = ( MoTimeline.me.baseJD - MoTimeline.me.beginJD ) / MoTimeline.me.duration;
		}

		private function onScaleTimeline( event:TimelineEvent ):void
		{
			updateScrollRange();
			
//			super.setMaskSize( maskSize );
		}

		private function onInitTimeline( event:TimelineEvent ):void
		{
			updateScrollRange();
			
			super.setMaskSize( super.size );

			eventManager.addEventListener( ASliderEvent.CHANGE_VALUE, onChangePosition );
		}

		private function updateScrollRange():void
		{
			var minVal:Number = 0;
			var maxVal:Number = MoTimeline.me.duration * MoTimeline.me.scale;
			super.setScrollRange( minVal, maxVal );
		}

		private function onChangePosition( event:ASliderEvent ):void
		{
			_isMouse = true;
			MoTimeline.me.baseJD = MoTimeline.me.beginJD + event.position * MoTimeline.me.duration;
			_isMouse = false;
		}


		override public function kill():void
		{
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onScaleTimeline );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onBaseChange );

			super.kill();
		}
	}
}
