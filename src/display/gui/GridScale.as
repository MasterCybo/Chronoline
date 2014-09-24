package display.gui {
	import data.MoTimeline;

	import display.DateLineFactory;

	import ru.arslanov.core.utils.DateUtils;

	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GridScale extends ASprite {

		static private const STEPS_JD:Array = [
					1000 * JDUtils.DAYS_PER_YEAR    // 0: 1000 лет
					, 100 * JDUtils.DAYS_PER_YEAR   // 1: 100 лет
					, 10 * JDUtils.DAYS_PER_YEAR    // 2: 10 лет
					, JDUtils.DAYS_PER_YEAR         // 3: 1 год
					, JDUtils.DAYS_PER_YEAR / 12    // 4: 1 месяц
					, 1                             // 5: 1 день
					, 1 / 24                        // 6: 1 час
					, 1 / 24 / 10                   // 7: 10 минут
					, 1 / 24 / 60                   // 8: 1 минута
		];

		private var _baseJD:Number = 0;
		private var _stepJD:Number = 0;
		private var _width:uint;
		private var _height:uint;
		private var _markerMode:uint = 0;
		private var _scale:Number = 1;

		public function GridScale( width:uint, height:uint ) {
			_width = width;
			_height = height;

			super();
		}

		public function reset():void
		{
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
			var offsetBeginJD:Number = jdb - apxBeginJD;
			var date:Object = JDUtils.JDToGregorian(apxBeginJD);
			var step:Number = DateUtils.getDaysMonth(date.year, date.month);
			var jdVis:Number = jdb;
			var apxJDVis:Number = approxJD( jdVis );

			var dateLine:ASprite;
			var len:uint = numSteps + 1;


			switch ( true ) {
				case _stepJD >= STEPS_JD[2]:
					_markerMode = DateLineFactory.MODE_ONLY_YEAR;
					break;
				case _stepJD >= STEPS_JD[3]:
					_markerMode = DateLineFactory.MODE_MONTH;
					break;
				default:
					_markerMode = DateLineFactory.MODE_FULL_DATE;
			}

//			Log.traceText( ">>> Begin : " + jdb + " = " + JDUtils.getFormatString(jdb) + " => " + JDUtils.getFormatString( approxJD( jdb ) ) );

			killChildren();

			for ( var i:int = 0; i <= len; i++ ) {
//				Log.traceText( i + " - Draw : " + jdVis + " = " + JDUtils.getFormatString( jdVis ) + " => " + JDUtils.getFormatString( approxJD( jdVis ) ) );

				dateLine = DateLineFactory.createDateMarker( approxJD( apxJDVis ), _width, _markerMode );
				dateLine.y = Math.floor( (-offsetBeginJD + jdVis - jdb) * _scale );
//				if( !contains( dateLine ) ){
					addChild( dateLine );
//				}


				if (_stepJD > STEPS_JD[5] && _stepJD <= STEPS_JD[4]) {
					date = JDUtils.JDToGregorian(jdVis);
					step = DateUtils.getDaysMonth(date.year, date.month);
				} else {
					step = _stepJD;
				}
				
				jdVis += _stepJD;
				apxJDVis += step;
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
//				year = approximation( year, _stepJD / 365 );
				year = approximation( year, Math.floor( _stepJD / JDUtils.DAYS_PER_YEAR ) );
//				year = approximation( year, Math.floor( _stepJD / DateUtils.getDaysYear(year) ) );
			}

			if (_stepJD >= STEPS_JD[4] ) { // >= 1 месяца
				day = approximation( day - 1, JDUtils.DAYS_PER_MONTH );
			}

			return JDUtils.gregorianToJD( year, month, day );
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
			super.kill();
		}
	}

}