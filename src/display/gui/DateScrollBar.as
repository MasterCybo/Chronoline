/**
 * Created by Artem on 21.05.2014.
 */
package display.gui
{
	import data.MoTimeline;

	import display.components.TimelineMiniMap;

	import display.skins.SBDateThumb;

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
		public function DateScrollBar( size:Number = 100 )
		{
			super( size );
		}

		override public function init():*
		{
			super.wheelSteps = 100;
//			super.setBody( new ScrollbarBody( 20, super.size ).init() );
			super.setBody( new TimelineMiniMap( 20, super.size ).init() );
			super.setThumb( new SBDateThumb( 20, 20 ).init() );

			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onScaleTimeline );

			return super.init();
		}

		private function onScaleTimeline( event:TimelineEvent ):void
		{
			updateScrollRange();
			
			traceParams();
			
//			super.setMaskSize( maskSize );
		}

		private function onInitTimeline( event:TimelineEvent ):void
		{
			updateScrollRange();
			
			super.setMaskSize( super.size );

			traceParams();
			
			eventManager.addEventListener( ASliderEvent.CHANGE_VALUE, onChangePosition );
		}

		private function updateScrollRange():void
		{
			var minVal:Number = 0;
			var maxVal:Number = MoTimeline.me.duration * MoTimeline.me.scale;
			super.setScrollRange( minVal, maxVal );
		}

		private function traceParams():void
		{
			
			return;
			
			Log.traceText( "---------------------------------------------------------------------" );
			Log.traceText( "MoTimeline.me.beginJD : " + MoTimeline.me.beginJD );
			Log.traceText( "MoTimeline.me.endJD : " + MoTimeline.me.endJD );
			Log.traceText( "MoTimeline.me.duration : " + MoTimeline.me.duration );

			var durScaled:Number = MoTimeline.me.duration * MoTimeline.me.scale;

			Log.traceText( "durScaled : " + durScaled );

			var minVal:Number = 0;
			var maxVal:Number = MoTimeline.me.duration * MoTimeline.me.scale;

			Log.traceText("minVal - maxVal : " + minVal + " - " + maxVal);
			
			Log.traceText( "size : " + super.size );
			Log.traceText( "maskSize : " + super.maskSize );
			
			var thumb:ASprite = super.getThumb();
			Log.traceText( "thumb.visible : " + thumb.visible );
			Log.traceText( "thumb.width x height : " + thumb.width + " x " + thumb.height );
			Log.traceText( "thumb.x, y : " + thumb.x + ", " + thumb.y );
			
		}
		
		private function onChangePosition( event:ASliderEvent ):void
		{
			MoTimeline.me.baseJD = MoTimeline.me.beginJD + event.position * MoTimeline.me.duration;
		}
	}
}
