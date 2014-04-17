package display.gui {
	import data.MoTimeline;
	import display.components.DateGraduation;
	import events.TimelineEvent;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GridScale extends ASprite {
		
		private var _offsetJD:Number; // Величина изменнения MoTimeline.me.currentDateJD
		private var _oldCurJD:Number; // Предыдущее значение MoTimeline.me.currentDateJD
		
		private var _width:uint;
		private var _height:uint;
		
		public function GridScale( width:uint, height:uint ) {
			_width = width;
			_height = height;
			
			super();
		}
		
		override public function init():* {
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onScaleChange );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onDateChange );
			
			return super.init();
		}
		
		private function onDateChange( ev:TimelineEvent ):void {
			//var yCenter:Number = _height / 2;
			//var djd:Number = yCenter / MoTimeline.me.scale;
			//Log.traceText( "djd : " + djd );
			//var jd:Number = MoTimeline.me.currentDateJD - djd;
			//Log.traceText( "jd : " + jd );
			
			_offsetJD = MoTimeline.me.baseJD - _oldCurJD;
			
			Log.traceText( "_offsetJD : " + _offsetJD );
			
			//var deltaJD:Number = dy / MoTimeline.me.scale;
			
			_oldCurJD = MoTimeline.me.baseJD;
		}
		
		private function onScaleChange( ev:TimelineEvent ):void {
			Log.traceText( "*execute* GridScale.onScaleChange" );
			
			Log.traceText( "MoTimeline.me.scale : " + MoTimeline.me.scale );
			
			var totalDur:Number = MoTimeline.me.duration;
			var totalYears:Number = totalDur / 365.25;
			Log.traceText( "Total years : " + totalYears );
			
			var heightJD:Number = _height / MoTimeline.me.scale;
			var heightYears:Number = heightJD / 365.25;
			Log.traceText( "heightJD : " + heightJD );
			Log.traceText( "heightYears : " + heightYears );
		}
		
		private function onInitTimeline( ev:TimelineEvent ):void {
			Log.traceText( "*execute* GridScale.onInitTimeline" );
			
			//Log.traceText( "MoTimeline.me.scale : " + MoTimeline.me.scale );
			//
			//var totalDur:Number = MoTimeline.me.duration;
			//var totalYears:Number = totalDur / 365.25;
			//Log.traceText( "Total years : " + totalYears );
			//
			//var heightJD:Number = _height * MoTimeline.me.scale;
			//var heightYears:Number = heightJD / 365.25;
			//Log.traceText( "heightJD : " + heightJD );
			//Log.traceText( "heightYears : " + heightYears );
			
			draw();
		}
		
		private function update():void {
			draw();
		}
		
		private function draw():void {
			var stepTime:Number = MoTimeline.me.duration / 10;
			var stepY:Number = _height / 10;
			
			killChildren();
			
			for ( var i:int = 0; i < 10; i++ ) {
				Log.traceText( i + " add" );
				var dateGrad:DateGraduation = new DateGraduation( MoTimeline.me.beginJD + i * stepTime, _width ).init();
				dateGrad.y = i * stepY;
				addChild( dateGrad );
			}
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width( value:Number ):void {
			_width = value;
			
			draw();
		}
		
		override public function get height():Number {
			return _height;
		}
		
		override public function set height( value:Number ):void {
			_height = value;
			
			draw();
		}
		
	}

}