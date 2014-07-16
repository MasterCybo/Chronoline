package display.gui {
	import data.MoTimeline;

	import display.components.DateGraduation;

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

		static private const MONTH:Number = 0.08333; // 1 year / 12 months
		static private const WEEK:Number = JDUtils.WEEKS_PER_MONTH / 7;
		
		static private var _pool:Array = [];
		static private var _displayed:Object = {}; // jd = DateGraduation

		private var _oldBaseJD:Number = 0; // Предыдущее значение MoTimeline.me.baseJD
		private var _offsetJD:Number = 0; // Величина изменения MoTimeline.me.baseJD
		private var _fitJD:Number = 0; // Величина смещения MoTimeline.me.baseJD, для отображения круглых дат 

		private var _width:uint;
		private var _height:uint;
		private var _stepJD:Number = 0;
		private var _div:Number = 0;
		private var _yCenter:Number = 0;

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
			_oldBaseJD = MoTimeline.me.baseJD;

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

			switch ( true ) {
				case heightYears <= WEEK:
					_stepJD = 1; // шаг = 1 день 
					break;
				case heightYears <= MONTH:
					_stepJD = JDUtils.WEEKS_PER_MONTH; // шаг = 
					break;
				case heightYears <= 1:
					_stepJD = JDUtils.DAYS_PER_MONTH; // шаг = 1 месяц
					break;
				case heightYears <= 5:
					_stepJD = JDUtils.DAYS_PER_YEAR * 0.5; // шаг = 6 месяцев
					break;
				case heightYears <= 15:
					_stepJD = JDUtils.DAYS_PER_YEAR; // шаг = 
					break;
				case heightYears <= 20:
					_stepJD = JDUtils.DAYS_PER_YEAR * 2; // шаг = 
					break;
				case heightYears <= 50:
					_stepJD = JDUtils.DAYS_PER_YEAR * 5; // шаг = 5 лет
					break;
				case heightYears <= 100:
					_stepJD = JDUtils.DAYS_PER_YEAR * 10; // шаг = 10 лет
					break;
				default:
//					_stepJD = 1; // шаг = 1 день
			}
			
			Log.traceText( "\t_step years : " + ( _stepJD / JDUtils.DAYS_PER_YEAR ) );
			
			_div = heightJD / _stepJD;
			
			Log.traceText( "\t\t_div : " + _div );

			_fitJD = MoTimeline.me.beginJD;

			draw();
		}

		/*private function update():void {
		 draw();
		 }*/


		private function draw():void {
			killChildren();

			var dateGrad:DateGraduation;

			var len:uint = _div + 1;
			var lenHalf:Number = int( len / 2 );

			for ( var i:int = 0; i <= len; i++ ) {
				var jdi:Number = ( -lenHalf + i ) * _stepJD - _offsetJD;
				var yy:Number = _yCenter + MoTimeline.me.scale * ( jdi );
				var jd:Number = MoTimeline.me.baseJD + jdi;

				dateGrad = new DateGraduation( jd, _width, Settings.GRID_TEXT_COLOR, Settings.GRID_LINE_COLOR ).init();
				addChild( dateGrad );


				dateGrad.y = yy;
			}
			if ( Math.abs( _offsetJD ) >= _stepJD ) {
				_offsetJD = Calc.sign( _offsetJD ) * ( Math.abs( _offsetJD ) - _stepJD );
			}
		}

		/*private function draw():void {
//			Log.traceText( "*execute* GridScale.draw" );

			var dateGrad:DateGraduation;

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
							dateGrad = new DateGraduation( jd, _width ).init();
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

			_pool.length = 0;
			_displayed = null;

			super.kill();
		}
	}

}