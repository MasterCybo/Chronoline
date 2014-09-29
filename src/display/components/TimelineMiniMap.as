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
		static public const GAP:Number = 1;
		static public const MIN_WIDTH:Number = 2;

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
			drawBg();

			MoTimeline.me.eventManager.addEventListener(TimelineEvent.INITED, onInitTimeline);
			
			return super.init();
		}

		private function onInitTimeline( event:TimelineEvent ):void
		{
			draw();
		}

		override public function set width( value:Number ):void
		{
			if ( value == _width ) return;

			_width = value;

			draw();
		}

		override public function set height( value:Number ):void
		{
			if ( value == _height ) return;

			_height = value;

			draw();
		}

		private function draw():void
		{
			killChildren();
			drawBg();

			var entities:Array = EntityManager.getArrayEntities();
			var len:uint = entities.length;
			var len2:uint = len + 1;
			var moEnt:MoEntity;
			var picEnt:ABitmap;

			var ww:Number = Math.max( MIN_WIDTH, (_width - GAP * len2 ) / len );
			var kf:Number = _height / MoTimeline.me.duration;

			for ( var i:int = 0; i < len; i++ ) {
				moEnt = entities[i];
				picEnt = ABitmap.fromColor( Settings.MIN_MAP_COLOR_ENT, ww, Math.max( Settings.MIN_MAP_SIZE_ENTITY, kf * moEnt.duration ) ).init();
				picEnt.x = GAP + (picEnt.width + GAP) * i;
				picEnt.y = kf * (moEnt.beginPeriod.beginJD - MoTimeline.me.beginJD);
				addChild( picEnt );
			}
		}

		private function drawBg():void
		{
			_bg = ABitmap.fromColor( 0xc0c0c0, _width, _height ).init();
			addChildAt( _bg, 0 );
		}
	}
}
