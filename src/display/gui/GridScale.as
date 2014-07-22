package display.gui {
	import data.MoTimeline;

	import display.DateLineFactory;

	import events.TimelineEvent;

	import ru.arslanov.core.utils.Calc;
	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GridScale extends ASprite {

		static private const MONTH:Number = 0.08333; // Месяц, как часть года. 1 year / 12 months
		static private const WEEK:Number = 0.019; // Неделя, как часть года
		
		static private var _displayed:Object = {}; // jd = DateLine

		private var _oldBaseJD:Number = 0; // Предыдущее значение MoTimeline.me.baseJD
		private var _offsetJD:Number = 0; // Величина изменения MoTimeline.me.baseJD
		private var _fitJD:Number = 0; // Величина смещения MoTimeline.me.baseJD, для отображения круглых дат 

		private var _width:uint;
		private var _height:uint;
		private var _stepJD:Number = 0;
		private var _div:Number = 0;
		private var _yCenter:Number = 0;
		private var _markerMode:uint = 0;

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

		private function onInitTimeline( ev:TimelineEvent ):void {
			_oldBaseJD = MoTimeline.me.baseJD;
			_yCenter = _height / 2;
			_stepJD = 0;
			_offsetJD = 0;
			_div = 0;

			updateScale();
			draw();
		}

		private function onDateChange( ev:TimelineEvent ):void {
//			Log.traceText( "*execute* GridScale.onDateChange" );

			var dJD:Number = MoTimeline.me.baseJD - _oldBaseJD;

			_offsetJD += dJD;
			_oldBaseJD = MoTimeline.me.baseJD - _fitJD;

			draw();
		}

		private function onScaleChange( ev:TimelineEvent ):void {
			updateScale();
		}

		private function updateScale():void {
//			Log.traceText( "*execute* GridScale.updateScale" );

			var heightJD:Number = _height / MoTimeline.me.scale;
			var heightYears:Number = heightJD / JDUtils.DAYS_PER_YEAR;
			
			Log.traceText( "heightYears : " + heightYears );

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
			
			Log.traceText( "\t_step years : " + ( _stepJD / JDUtils.DAYS_PER_YEAR ) );
			
			_div = heightJD / _stepJD;
			
			Log.traceText( "\t\t_div : " + _div );

			draw();
		}

		private function updateParams( stepOfYears:Number ):void {
			_stepJD = JDUtils.DAYS_PER_YEAR * stepOfYears;

			Log.traceText( "...beginJD : " + MoTimeline.me.baseJD + " = " + JDUtils.getFormatString( MoTimeline.me.baseJD ) );
			var yy:Number = JDUtils.JDToDate( MoTimeline.me.baseJD ).year;
			Log.traceText( "yy : " + yy );
			var abc:Number = yy - yy%50;
			Log.traceText( "abc : " + abc );
			var abcJD:Number = JDUtils.dateToJD( abc );
			Log.traceText( "abcJD : " + abcJD );
			
			_fitJD = MoTimeline.me.baseJD - abcJD + 0.5;
			
			Log.traceText( "_fitJD : " + _fitJD + " = " + JDUtils.getFormatString( MoTimeline.me.baseJD - _fitJD + 0.5 ) );
		}


		private function draw():void {
			killChildren();

			var dateLine:ASprite;

			var len:uint = _div + 1;
			var lenHalf:Number = int( len / 2 );

			for ( var i:int = 0; i <= len; i++ ) {
				var jdi:Number = ( -lenHalf + i ) * _stepJD - _offsetJD;
				var yy:Number = _yCenter + MoTimeline.me.scale * ( jdi );
				var jd:Number = MoTimeline.me.baseJD + jdi;

//				dateLine = _displayed[ jd ] as ASprite;
				
//				if ( !dateLine ) {
					dateLine = DateLineFactory.createDateMarker( jd, _width, _markerMode );
					dateLine.name = "" + jd;
					addChild( dateLine );
					
//					_displayed[ jd ] = dateLine;
//				}

				dateLine.y = yy;
			}
			
			if ( Math.abs( _offsetJD ) >= _stepJD ) {
				_offsetJD = Calc.sign( _offsetJD ) * ( Math.abs( _offsetJD ) - _stepJD );
			}
		}

		/*private function draw():void {
//			Log.traceText( "*execute* GridScale.draw" );

			var dateGrad:DateLine;

			var len:uint = _div + 1;
			var lenHalf:Number = int( len / 2 );
			var deltaY:Number = MoTimeline.me.scale * lenHalf * _stepJD;
			var minY:Number = _yCenter - deltaY;
			var maxY:Number = _yCenter + deltaY;
//			Log.traceText( "    minY, maxY : " + minY + ", " + maxY );

			for ( var i:int = 0; i <= len; i++ ) {
				var jdi:Number = ( -lenHalf + i ) * _stepJD - _offsetJD;
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

			if ( Math.abs( _offsetJD ) >= _stepJD ) {
				_offsetJD = Calc.sign( _offsetJD ) * ( Math.abs( _offsetJD ) - _stepJD );
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

			updateScale();
		}

		override public function kill():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onScaleChange );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onDateChange );

			_displayed = null;

			super.kill();
		}
	}

}