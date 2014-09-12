package display.gui {
	import collections.EntityManager;

	import data.MoTimeline;

	import display.DateLineFactory;

	import ru.arslanov.core.utils.Calc;
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
		private var _oldBaseJD:Number = 0;      // Старое значение MoTimeline.me.baseJD
		private var _offsetBaseJD:Number = 0;   // Величина смещения MoTimeline.me.baseJD
		private var _approxBeginJD:Number = 0;   // Величина аппроксимации MoTimeline.me.baseJD до ближайшей круглой даты
		private var _stepJD:Number = 0;         // Шаг масштабных линий

		private var _width:uint;
		private var _height:uint;
		private var _numSteps:Number = 0;
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

			_scale = MoTimeline.me.scale;
			_baseJD = MoTimeline.me.baseJD;
			_oldBaseJD = _baseJD;
			_yCenter = _height / 2;
			_stepJD = 0;
			_offsetBaseJD = 0;
			_numSteps = 0;

			prepareScale();
			draw();
		}

		public function updateBaseDate():void {
//			Log.traceText( "*execute* GridScale.updateBaseDate" );
			
			_baseJD = MoTimeline.me.baseJD;
			_offsetBaseJD += _baseJD - _oldBaseJD;
			_oldBaseJD = _baseJD;

			draw();
		}

		public function updateScale():void {
			_scale = MoTimeline.me.scale;
			
			prepareScale();
			draw();
		}

		private function prepareScale():void {
			Log.traceText( "*execute* GridScale.prepareScale" );

			var jdPerHeight:Number = _height / _scale;
			var yearsPerHeight:Number = jdPerHeight / JDUtils.DAYS_PER_YEAR;
			
			Log.traceText( "jdPerHeight : " + jdPerHeight );
			Log.traceText( "yearsPerHeight : " + yearsPerHeight );

			var idx:int = -1;
			while ( STEPS_JD[++idx] > jdPerHeight ) {
				Log.traceText( "idx : " + idx );
			}

			Log.traceText( "STEPS_JD[" + idx + "] : " + (STEPS_JD[idx] / JDUtils.DAYS_PER_YEAR) );

			_stepJD = STEPS_JD[idx];
			_numSteps = jdPerHeight / _stepJD;

//			var baseJD:Number = MoTimeline.me.baseJD;
			var baseJD:Number = EntityManager.period.beginJD;
			var date:Object = JDUtils.JDToGregorian( baseJD );
			var apxYear:Number = date.year;
			var apxMonth:Number = date.month;
			var apxDay:Number = date.date;
			
			Log.traceText( "1 apxYear : " + apxYear );
			Log.traceText( "1 apxMonth : " + apxMonth );
			Log.traceText( "1 apxDay : " + apxDay );

			if ( jdPerHeight > JDUtils.DAYS_PER_YEAR ) {
				apxYear = approximation( apxYear, _stepJD / JDUtils.DAYS_PER_YEAR );
				apxMonth = approximation( apxMonth, 12 );
				apxDay = approximation( apxDay, 31 );
			}

			Log.traceText( "2 apxYear : " + apxYear );
			Log.traceText( "2 apxMonth : " + apxMonth );
			Log.traceText( "2 apxDay : " + apxDay );

			_approxBeginJD = JDUtils.gregorianToJD( apxYear, apxMonth, apxDay ) + 0.5;

			Log.traceText( "_stepJD : " + _stepJD );
			Log.traceText( "_numSteps : " + _numSteps );
			Log.traceText( "...beginJD : " + baseJD + " = " + JDUtils.getFormatString(baseJD) );
			Log.traceText( "_approxBeginJD : " + _approxBeginJD + " = " + JDUtils.getFormatString(_approxBeginJD) );
		}

		private function approximation( value:Number, base:Number ):Number
		{
			var mod:Number = value % base;
//			var k:Number = mod / base;
//			Log.traceText( base + " / " + mod + " = " + k );
			
//			return k >= 0.5 ? value + ( base - mod ) : value - mod;
			var val:Number = value - mod;
			return val == 0 ? 1 : val;
		}

		private function draw():void {
			killChildren();

			var dateLine:ASprite;
			var len:uint = _numSteps + 1;
			
			for ( var i:int = 0; i <= len; i++ ) {
				var jd:Number = _approxBeginJD + _stepJD * i;

				Log.traceText( i + " jd : " + jd + " = " + JDUtils.getFormatString(jd) );
				
				dateLine = DateLineFactory.createDateMarker( jd, _width, _markerMode );
				dateLine.name = "" + jd;
				addChild( dateLine );

//				dateLine.y = yy;
			}
			
			if ( Math.abs( _offsetBaseJD ) >= _stepJD ) {
				_offsetBaseJD = Calc.sign( _offsetBaseJD ) * ( Math.abs( _offsetBaseJD ) - _stepJD );
			}
		}

		/*private function draw():void {
//			Log.traceText( "*execute* GridScale.draw" );

			var dateGrad:DateLine;

			var len:uint = _numSteps + 1;
			var lenHalf:Number = int( len / 2 );
			var deltaY:Number = MoTimeline.me.scale * lenHalf * _stepJD;
			var minY:Number = _yCenter - deltaY;
			var maxY:Number = _yCenter + deltaY;
//			Log.traceText( "    minY, maxY : " + minY + ", " + maxY );

			for ( var i:int = 0; i <= len; i++ ) {
				var jdi:Number = ( -lenHalf + i ) * _stepJD - _offsetBaseJD;
				var yy:Number = _yCenter + MoTimeline.me.scale * ( jdi );
				var jd:Number = MoTimeline.me.baseJD + jdi;

				dateGrad = _displayed[jd];

				if ( (yy >= minY ) && ( yy <= maxY ) ) {
					if( !dateGrad ) {
						if( _pool.length ) {
//							Log.traceText( "=== Get from Pool : " + JDUtils.getFormatString( jd ) );
							dateGrad = _pool.pop();
							dateGrad.width = _width;
							dateGrad.jd = jd;
						} else {
//							Log.traceText( "+++ Create new : " + JDUtils.getFormatString( jd ) );
							dateGrad = new DateLine( jd, _width ).init();
						}

						if( !contains( dateGrad ) ) {
							addChild( dateGrad );
						}

						_displayed[jd] = dateGrad;
					}

					dateGrad.y = yy;
				} else {
					if ( dateGrad ) {
//						Log.traceText( "--- Remove : " + JDUtils.getFormatString( jd ) );

						_pool.push( dateGrad );
						removeChild( dateGrad );
						delete _displayed[jd];
					}
				}
			}

			// Чистим не отображаемые при изменении размеров приложения
//			var nm:String;
//			for ( nm in _displayed ) {
//				dateGrad = _displayed[nm];
//
//				if ( !contains( dateGrad ) ) {
//					_pool.push( dateGrad );
//					removeChild( dateGrad );
//					delete _displayed[jd];
//				}
//			}

			if ( Math.abs( _offsetBaseJD ) >= _stepJD ) {
				_offsetBaseJD = Calc.sign( _offsetBaseJD ) * ( Math.abs( _offsetBaseJD ) - _stepJD );
			}
		}*/

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

			prepareScale();
			draw();
		}

		override public function kill():void {
			_displayed = null;

			super.kill();
		}
	}

}