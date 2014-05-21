/**
 * Created by Artem on 21.05.2014.
 */
package display.gui
{
	import data.MoTimeline;

	import display.skins.SBDateThumb;
	import display.skins.ScrollbarBody;

	import events.TimelineEvent;

	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.gui.AScrollBar;
	import ru.arslanov.flash.gui.events.ASliderEvent;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DateScrollBar extends AScrollBar
	{
		public function DateScrollBar( size:Number = 100 )
		{
			super( size );
		}

		override public function init():*
		{
			super.wheelSteps = 100;
			super.setBody( new ScrollbarBody( 20, super.size ).init() );
			super.setThumb( new SBDateThumb( 20, 20 ).init() );

			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onScaleTimeline );

			return super.init();
		}

		private function onScaleTimeline( event:TimelineEvent ):void
		{
			var durHeight:Number = MoTimeline.me.duration * MoTimeline.me.scale;
			
			Log.traceText( "durHeight : " + durHeight );
			
			var abc:Number = super.size * MoTimeline.me.scale;

//			Log.traceText( "abc : " + abc );

			var maskSize:Number = abc;

			Log.traceText( "maskSize : " + maskSize );

			super.setMaskSize( maskSize );
		}

		private function onInitTimeline( event:TimelineEvent ):void
		{
			Log.traceText( "MoTimeline.me.beginJD : " + MoTimeline.me.beginJD );
			Log.traceText( "MoTimeline.me.endJD : " + MoTimeline.me.endJD );
			Log.traceText( "MoTimeline.me.duration : " + MoTimeline.me.duration );

			var minVal:Number = MoTimeline.me.beginJD;
			var maxVal:Number = MoTimeline.me.endJD;
			super.setScrollRange( minVal, maxVal );
			super.setMaskSize( MoTimeline.me.duration );
			
			Log.traceText( "super.getThumb().x : " + super.getThumb().x );
			
			eventManager.addEventListener( ASliderEvent.CHANGE_VALUE, onChangePosition );
		}

		private function onChangePosition( event:ASliderEvent ):void
		{
			MoTimeline.me.baseJD = MoTimeline.me.beginJD + event.value * MoTimeline.me.duration;
		}
	}
}
