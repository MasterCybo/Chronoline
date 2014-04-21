package display.gui {
	import data.MoTimeline;

	import display.components.DateGraduation;

	import events.TimelineEvent;

	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GridScale extends ASprite {

		private var _offsetJD:Number; // Величина изменнения MoTimeline.me.currentDateJD
		private var _oldBaseJD:Number; // Предыдущее значение MoTimeline.me.currentDateJD

		private var _width:uint;
		private var _height:uint;
		private var _stepJD:Number;
		private var _div:Number;
		private var _yCenter:Number;

		public function GridScale( width:uint, height:uint ) {
			_width = width;
			_height = height;

			super();
		}

		override public function init():* {
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onScaleChange );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onDateChange );

			_yCenter = _height / 2;

			return super.init();
		}

		private function onDateChange( ev:TimelineEvent ):void {
			//var yCenter:Number = _height / 2;
			//var djd:Number = yCenter / MoTimeline.me.scale;
			//Log.traceText( "djd : " + djd );
			//var jd:Number = MoTimeline.me.currentDateJD - djd;
			//Log.traceText( "jd : " + jd );

			_offsetJD = MoTimeline.me.baseJD - _oldBaseJD;

			Log.traceText( "_offsetJD : " + _offsetJD );

			//var deltaJD:Number = dy / MoTimeline.me.scale;

			_oldBaseJD = MoTimeline.me.baseJD;

			draw();
		}

		private function onScaleChange( ev:TimelineEvent ):void {
			updateScale();
		}

		private function onInitTimeline( ev:TimelineEvent ):void {
			updateScale();
			draw();
		}

		private function updateScale():void {
			Log.traceText( "*execute* GridScale.updateScale" );
			Log.traceText( "MoTimeline.me.scale : " + MoTimeline.me.scale );

			var totalDur:Number = MoTimeline.me.duration;
			var totalYears:Number = totalDur / JDUtils.DAYS_PER_YEAR;
			//Log.traceText( "Total duration : " + totalDur );
			Log.traceText( "Total years : " + totalYears );

			var heightJD:Number = _height / MoTimeline.me.scale;
			var heightYears:Number = heightJD / JDUtils.DAYS_PER_YEAR;
			//Log.traceText( "heightJD : " + heightJD );
			Log.traceText( "Years/height : " + heightYears );

			if ( heightYears <= 1 ) {
				_stepJD = JDUtils.DAYS_PER_YEAR / 12;
			} else if ( heightYears <= 10 ) {
				_stepJD = JDUtils.DAYS_PER_YEAR;
			} else if ( heightYears <= 50 ) {
				_stepJD = 5 * JDUtils.DAYS_PER_YEAR;
			} else if ( heightYears <= 100 ) {
				_stepJD = 10 * JDUtils.DAYS_PER_YEAR;
			} else if ( heightYears <= 500 ) {
				_stepJD = 50 * JDUtils.DAYS_PER_YEAR;
			} else if ( heightYears <= 1000 ) {
				_stepJD = 100 * JDUtils.DAYS_PER_YEAR;
			} else {
				_stepJD = 1000 * JDUtils.DAYS_PER_YEAR;
			}

			Log.traceText( "Step years : " + (_stepJD / JDUtils.DAYS_PER_YEAR) );
			Log.traceText( "Step JD : " + _stepJD );

			//_div = heightJD / _stepJD;

			//Log.traceText( "_div : " + _div );

			_div = MoTimeline.me.duration / _stepJD;
			Log.traceText( "Total divide : " + _div );

			var baseDiv:Number = (MoTimeline.me.baseJD - MoTimeline.me.beginJD) / _stepJD;
			Log.traceText( "Divide before baseJD : " + baseDiv );

			draw();
		}

		private function update():void {
			draw();
		}

		private function draw():void {
			Log.traceText( "*execute* GridScale.draw" );
			var deltaJD:Number = MoTimeline.me.baseJD - MoTimeline.me.beginJD;
			var divJD:Number = deltaJD / _stepJD;
			var modBaseJD:Number = deltaJD % _stepJD;
			var offsetJD:Number = modBaseJD * _stepJD;

			Log.traceText( "	deltaJD : " + deltaJD );
			Log.traceText( "	divJD : " + divJD );
			Log.traceText( "	modBaseJD : " + modBaseJD );
			Log.traceText( "	offsetJD : " + offsetJD );

			var heightJD:Number = _height / MoTimeline.me.scale;
			var jd0:Number = MoTimeline.me.baseJD - heightJD / 2;
			var divBefore0:Number = (jd0 - MoTimeline.me.beginJD) / _stepJD;
			Log.traceText( "	divBefore0 : " + divBefore0 );

			killChildren();

			for ( var i:int = 0; i < _div; i++ ) {
				var jd:Number = jd0 + offsetJD + i * _stepJD;
				var yy:Number = dateToY( jd );
				Log.traceText( "		yy : " + yy );

				var dateGrad:DateGraduation = new DateGraduation( jd, _width ).init();
				dateGrad.y = yy;
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

			_yCenter = _height / 2;

			draw();
		}

		private function dateToY( jd:Number ):Number {
			return _yCenter + MoTimeline.me.scale * ( jd - MoTimeline.me.baseJD );
		}
	}

}