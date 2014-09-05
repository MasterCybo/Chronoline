package display.gui {
	import data.MoTimeline;

	import display.DateLineFactory;

	import events.TimelineEvent;

	import ru.arslanov.core.utils.Calc;
	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GridScale extends ASprite {

		static private const SCALE:Array = [
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

		private var _idxScale:uint = 0;

		static private const MONTH:Number = 0.08333; // Месяц, как часть года. 1 year / 12 months
		static private const WEEK:Number = 0.019; // Неделя, как часть года
		
		static private var _displayed:Object = {}; // jd = DateLine

		private var _baseJD:Number = 0;
		private var _oldBaseJD:Number = 0;      // Старое значение MoTimeline.me.baseJD
		private var _offsetBaseJD:Number = 0;   // Величина смещения MoTimeline.me.baseJD
		private var _approxBaseJD:Number = 0;   // Величина аппроксимации MoTimeline.me.baseJD до ближайшей круглой даты
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
		}

		private function prepareScale():void {
//			Log.traceText( "*execute* GridScale.prepareScale" );

			var heightJD:Number = _height / _scale;
//			Log.traceText( "heightJD : " + heightJD );
			var heightYears:Number = heightJD / JDUtils.DAYS_PER_YEAR;
			
//			Log.traceText( "heightYears : " + heightYears );

			_markerMode = DateLineFactory.MODE_FULL_DATE;
			if ( heightYears > 5 ) {
				_markerMode = DateLineFactory.MODE_ONLY_YEAR;
			}

			switch ( true ) {
				case heightYears <= WEEK:
					_stepJD = 1; // шаг = 1 день
					break;
				case heightYears <= MONTH:
//					_stepJD = JDUtils.WEEKS_PER_MONTH; // шаг = 1 неделя
//					_stepJD = JDUtils.DAYS_PER_MONTH / JDUtils.WEEKS_PER_MONTH; // шаг = 1 неделя
					updateParams( JDUtils.WEEKS_PER_MONTH / JDUtils.DAYS_PER_MONTH ); // шаг = 1 неделя
					break;
				case heightYears <= 1:
//					_stepJD = JDUtils.DAYS_PER_MONTH; // шаг = 1 месяц
					updateParams( 12 / JDUtils.DAYS_PER_YEAR ); // шаг = 1 месяц
					break;
				case heightYears <= 5:
					updateParams( 0.5 ); // шаг = 6 месяцев
					break;
				case heightYears <= 15:
					updateParams( 1 ); // шаг = 1 год
					break;
				case heightYears <= 20:
					updateParams( 2 ); // шаг = 2 года
					break;
				case heightYears <= 50:
					updateParams( 5 ); // шаг = 5 лет
					break;
				case heightYears <= 100:
					updateParams( 10 ); // шаг = 10 лет
					break;
				case heightYears <= 500:
					updateParams( 50 ); // шаг = 50 лет
					break;
				case heightYears <= 1000:
					updateParams( 100 ); // шаг = 100 лет
					break;
				default:
					updateParams( 500 ); // шаг = 500 лет
			}
			
//			Log.traceText( "\t_step years : " + ( _stepJD / JDUtils.DAYS_PER_YEAR ) );
			
			_numSteps = heightJD / _stepJD;
			
//			Log.traceText( "\t\t_numSteps : " + _numSteps );

			draw();
		}

		private function updateParams( stepOfYears:Number ):void {
			_stepJD = JDUtils.DAYS_PER_YEAR * stepOfYears;

//			Log.traceText( "...beginJD : " + _baseJD + " = " + JDUtils.getFormatString( _baseJD ) );
			
			var year:Number = JDUtils.JDToGregorian( _baseJD ).year;
			var deltaMod:Number = year - ( year % 50 );
			var deltaModJD:Number = JDUtils.gregorianToJD( deltaMod );
			
//			Log.traceText( "year : " + year );
//			Log.traceText( "deltaMod : " + deltaMod );
//			Log.traceText( "deltaModJD : " + deltaModJD );
			
			_approxBaseJD = MoTimeline.me.baseJD - deltaModJD + 0.5;
			
//			Log.traceText( "_approxBaseJD : " + _approxBaseJD + " = " + JDUtils.getFormatString( _baseJD - _approxBaseJD + 0.5 ) );
		}

		private function draw():void {
			killChildren();

			var dateLine:ASprite;

			var len:uint = _numSteps + 1;
			var lenHalf:Number = int( len / 2 );

			for ( var i:int = 0; i <= len; i++ ) {
				var jdi:Number = ( -lenHalf + i ) * _stepJD - _offsetBaseJD/* - _approxBaseJD*/;
				var yy:Number = _yCenter + _scale * ( jdi );
				var jd:Number = _baseJD + jdi;

//				dateLine = _displayed[ jd ] as ASprite;
				
//				if ( !dateLine ) {
					dateLine = DateLineFactory.createDateMarker( jd, _width, _markerMode );
					dateLine.name = "" + jd;
					addChild( dateLine );
					
//					_displayed[ jd ] = dateLine;
//				}

				dateLine.y = yy;
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
		}

		override public function kill():void {
			_displayed = null;

			super.kill();
		}
	}

}