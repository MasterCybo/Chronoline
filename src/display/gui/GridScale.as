package display.gui {
	import data.MoTimeline;

	import display.components.DateGraduation;

	import events.TimelineEvent;

	import flash.sampler.getMemberNames;

	import ru.arslanov.core.utils.Calc;
	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GridScale extends ASprite {

		static private var _pool:Array = [];
		static private var _displayed:Object = {}; // jd = DateGraduation

		private var _oldBaseJD:Number = 0; // Предыдущее значение MoTimeline.me.baseJD
		private var _offsetJD:Number = 0; // Величина изменнения MoTimeline.me.baseJD

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

			_div = heightJD / _stepJD;

			draw();
		}

		/*private function update():void {
		 draw();
		 }*/

		private function draw():void {
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