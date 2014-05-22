/**
 * Created by Artem on 22.05.2014.
 */
package display.components
{
	import collections.EntityManager;

	import data.MoEntity;

	import data.MoTimeline;

	import events.TimelineEvent;

	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TimelineMiniMap extends ASprite
	{
		private var _bg:ABitmap;
		private var _width:Number;
		private var _height:Number;
		
		public function TimelineMiniMap( width:Number = 10, height:Number = 10 )
		{
			_width = width;
			_height = height;
			
			super();
		}

		override public function init():*
		{
			MoTimeline.me.eventManager.addEventListener(TimelineEvent.INITED, onInitTimeline);
			
			return super.init();
		}

		private function onInitTimeline( event:TimelineEvent ):void
		{
			var entities:Array = EntityManager.getArrayEntities();
			var moEnt:MoEntity;
			var picEnt:ABitmap;
			
			var kf:Number = _height / MoTimeline.me.duration;

			for ( var i:int = 0; i < entities.length; i++ ) {
				moEnt = entities[i];
				picEnt = ABitmap.fromColor( 0x000000, 2, kf * moEnt.duration ).init();
				picEnt.x = (picEnt.width + 1) * i;
				picEnt.y = kf * (moEnt.beginPeriod.beginJD - MoTimeline.me.beginJD);
				addChild( picEnt );
			}
		}

		override public function set width( value:Number ):void
		{
			if ( value == _width ) return;

			_width = value;

			drawPic();
		}

		override public function set height( value:Number ):void
		{
			if ( value == _height ) return;

			_height = value;

			drawPic();
		}

		private function drawPic():void
		{
			if ( _bg ) _bg.kill();

//			_bg = ABitmap.fromColor( 0xDDDDDD, _width, _height ).init();
//			addChild( _bg );
		}
	}
}
