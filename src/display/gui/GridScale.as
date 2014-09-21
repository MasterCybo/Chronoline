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
			var apxBeginJD:Number = approxJD( jdb );
			var deltaBeginJD:Number = jdb - apxBeginJD;

			killChildren();

			var dateLine:ASprite;
			var len:uint = numSteps + 1;

			var date:Object = JDUtils.JDToGregorian(apxBeginJD);
			var step:Number = JDUtils.getDaysPerMonthGregorian(date.year, date.month);
			var jdVis:Number = jdb;
			var offsetVis:Number = 0;

			Log.traceText( ">>> jdb : " + jdb + " = " + JDUtils.getFormatString(jdb) );
			
			for ( var i:int = 0; i <= len; i++ ) {
				var apxJDVis:Number = approxJD( jdVis - offsetVis );
				
				
//				Log.traceText(i + " - step : " + step + ", jdBegin : " + jdb + " = " + JDUtils.getFormatString(jdb) );
//				Log.traceText("\tjdVis : " + jdVis + " = " + JDUtils.getFormatString(jdVis));
//				Log.traceText("\t\tapxJDVisible : " + apxJDVis + " = " + JDUtils.getFormatString(apxJDVis));
				
				dateLine = DateLineFactory.createDateMarker( apxJDVis, _width, _markerMode );
				addChild( dateLine );

				dateLine.y = (-deltaBeginJD + jdVis - jdb) * _scale;
				
				if (_stepJD <= STEPS_JD[4]) {
					date = JDUtils.JDToGregorian(jdVis);
					
					Log.traceText( i + " - jdVis : " + jdVis + " = " + date.month + " = " + JDUtils.getFormatString(jdVis) );
					
					step = JDUtils.getDaysPerMonthGregorian(date.year, date.month);
					offsetVis = date.date - 1;
					
					Log.traceText( "    offsetVis : " + offsetVis );
					Log.traceText( "    New step : " + step );
					Log.traceText( "    Next jdVis : " + (jdVis + step) + " = " + JDUtils.getFormatString(jdVis + step) );
					Log.traceText( "    Next apxJDVis : " + (jdVis + step - offsetVis) + " = " + JDUtils.getFormatString(jdVis + step - offsetVis) );
				} else {
					step = _stepJD;
				}
				
				jdVis += step;
			}
		}

		private function approxJD( jd:Number ):Number
		{
			var date:Object = JDUtils.JDToGregorian( jd );
			var year:Number = date.year;
			var month:Number = date.month;
			var day:Number = date.date;

//			Log.traceText( "month : " + month );

			if (_stepJD >= STEPS_JD[3] ) { // >= 1 года
				month = approximation( month - 1, 12 );
				year = approximation( year, _stepJD / JDUtils.DAYS_PER_YEAR );
			}

			if (_stepJD >= STEPS_JD[4] ) { // >= 1 месяца
				day = approximation( day - 1, JDUtils.DAYS_PER_MONTH );
			}

//			Log.traceText( "\tmonth : " + month );

			return JDUtils.gregorianToJD( year, month, day ) + 0.5;
		}

		private function approximation( value:Number, base:Number ):Number
		{
			var val:Number = value - ( value % base );
			return Math.max( 1, val );
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