package display.gui {
	import data.MoTimeline;

	import display.DateLineFactory;

	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GridScale extends ASprite {

		static private const STEPS_JD:Array = [
					1000 * JDUtils.DAYS_PER_YEAR    // 1000 лет
					, 100 * JDUtils.DAYS_PER_YEAR   // 100 лет
					, 10 * JDUtils.DAYS_PER_YEAR    // 10 лет
					, JDUtils.DAYS_PER_YEAR         // 1 год
					, JDUtils.DAYS_PER_YEAR / 12    // 1 месяц
					, 1                             // 1 день
					, 1 / 24                        // 1 час
					, 1 / 24 / 10                   // 10 минут
					, 1 / 24 / 60                   // 1 минута
		];

		private var _idxRange:uint = 0;

		static private const MONTH:Number = 0.08333; // Месяц, как часть года. 1 year / 12 months
		static private const WEEK:Number = 0.019; // Неделя, как часть года
		
		static private var _displayed:Object = {}; // jd = DateLine

		private var _baseJD:Number = 0;
		private var _stepJD:Number = 0;
		private var _oldBaseJD:Number = 0;      // Старое значение MoTimeline.me.baseJD
		private var _offsetBaseJD:Number = 0;   // Величина смещения MoTimeline.me.baseJD
		private var stepJD:Number = 0;         // Шаг масштабных линий

		private var _width:uint;
		private var _height:uint;
		private var numSteps:Number = 0;
		private var _yCenter:Number = 0;
		private var _markerMode:uint = 0;
		private var _scale:Number = 1;

		public function GridScale( width:uint, height:uint ) {
			_width = width;
			_height = height;

			super();
		}

		public function reset():void
		{
//			Log.traceText( "SCALE : " + SCALE );

			_oldBaseJD = _baseJD;
			_yCenter = _height / 2;
			stepJD = 0;
			_offsetBaseJD = 0;
			numSteps = 0;

			draw();
		}

		public function updateBaseDate():void {
			draw();
		}

		public function updateScale():void {
			draw();
		}

		private function draw():void
		{
			_scale = MoTimeline.me.scale;
			_baseJD = MoTimeline.me.baseJD;

			var jdH:Number = _height / _scale;
			var hJDH:Number = jdH / 2;
			var yearsPerHJDH:Number = hJDH / JDUtils.DAYS_PER_YEAR;
			var errorDays:Number = Math.floor( yearsPerHJDH / 4 );
			var jdb:Number = _baseJD - hJDH;
			var jde:Number = _baseJD + hJDH;

//			Log.traceText( "jdb : " + jdb + " = " + JDUtils.getFormatString(jdb) );
//			Log.traceText( "jde : " + jde + " = " + JDUtils.getFormatString(jde) );

			var idx:int = -1;
			while ( STEPS_JD[++idx] > jdH ) {
//				Log.traceText( "idx : " + idx );
			}
//			Log.traceText( "STEPS_JD[" + idx + "] : " + (STEPS_JD[idx] / JDUtils.DAYS_PER_YEAR) );

			_stepJD = STEPS_JD[idx];
			var numSteps:Number = jdH / _stepJD;
			var apxBaseJD:Number = approxJD( _baseJD );
			var apxBeginJD:Number = approxJD( jdb );
			var deltaBeginJD:Number = jdb - apxBeginJD;

			Log.traceText( "=======================================================" );

			Log.traceText( "_stepJD : " + _stepJD );
			Log.traceText( "_baseJD : " + _baseJD + " = " + JDUtils.getFormatString(_baseJD) );
			Log.traceText( "JD per Height : " + jdH );
			Log.traceText( "errorDays : " + errorDays );
			Log.traceText( "jdb : " + jdb + " = " + JDUtils.getFormatString(jdb) );
			Log.traceText( "apxBeginJD : " + apxBeginJD + " = " + JDUtils.getFormatString(apxBeginJD) );
//			Log.traceText( "deltaBeginJD : " + deltaBeginJD );

			Log.traceText( "----------------------------------" );

			killChildren();

			var dateLine:ASprite;
			var len:uint = numSteps + 1;

			for ( var i:int = 0; i <= len; i++ ) {
				var jdVis:Number = apxBeginJD + (_stepJD - 1) * i;
//				var jdVis:Number = approxJD( jdb + _stepJD * i );
				var jdPos:Number = -deltaBeginJD + _stepJD * i;

//				var djd:Number = jdVis - apxBeginJD;
//				var si:Number = _stepJD * i;

//				Log.traceText( i + " jdVis : " + jdVis + " = " + JDUtils.getFormatString(jdVis) );
//				Log.traceText( "djd : " + djd + " = si : " + si );

				dateLine = DateLineFactory.createDateMarker( jdVis, _width, _markerMode );
				addChild( dateLine );

				dateLine.y = jdPos * _scale;
//				Log.traceText( "dateLine.y : " + dateLine.y );
			}
		}

		private function approxJD( jd:Number ):Number
		{
			var date:Object = JDUtils.JDToGregorian( jd );
			var year:Number = date.year;
			var month:Number = date.month;
			var day:Number = date.date;

			if (_stepJD >= JDUtils.DAYS_PER_YEAR ) {
				year = approximation( year, _stepJD / JDUtils.DAYS_PER_YEAR );
			}

			if (_stepJD >= STEPS_JD[3] ) {
				month = approximation( month - 1, 12 );
			}

			if (_stepJD >= JDUtils.DAYS_PER_MONTH ) {
				day = approximation( day - 1, JDUtils.DAYS_PER_MONTH );
			}

			return JDUtils.gregorianToJD( year, month, day ) + 0.5;
		}

		private function approximation( value:Number, base:Number ):Number
		{
			var val:Number = value - ( value % base );
			return val == 0 ? 1 : val;
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

		override public function kill():void {
			_displayed = null;

			super.kill();
		}
	}

}