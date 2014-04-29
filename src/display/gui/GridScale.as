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

		static private var _pool:Array = [];
		static private var _displayed:Object = {}; // jd = DateGraduation

		private var _oldBaseJD:Number = NaN; // Предыдущее значение MoTimeline.me.baseJD
		private var _offsetJD:Number = 0; // Величина изменнения MoTimeline.me.baseJD
		private var _offsetY:Number = 0; //

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
			var dPx:Number = dJD * MoTimeline.me.scale;

			_offsetJD += dJD;
			_offsetY += dPx;

//			Log.traceText( "    Delta JD = px : " + dJD + " = " + dPx );
//			Log.traceText( "        Offset JD = px : " + _offsetJD + " = " + _offsetY );
//			Log.traceText( "        Step JD : " + _stepJD );

			_oldBaseJD = MoTimeline.me.baseJD;

			draw();
		}

		private function onScaleChange( ev:TimelineEvent ):void {
			updateScale();
		}

		private function updateScale():void {
//			Log.traceText( "*execute* GridScale.updateScale" );
//			Log.traceText( "MoTimeline.me.scale : " + MoTimeline.me.scale );

//			var totalDur:Number = MoTimeline.me.duration;
//			var totalYears:Number = totalDur / JDUtils.DAYS_PER_YEAR;
			//Log.traceText( "Total duration : " + totalDur );
//			Log.traceText( "Total years : " + totalYears );

			var heightJD:Number = _height / MoTimeline.me.scale;
			var heightYears:Number = heightJD / JDUtils.DAYS_PER_YEAR;
			//Log.traceText( "heightJD : " + heightJD );
//			Log.traceText( "Years/height : " + heightYears );

//			var oldStep:Number = _stepJD;

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

//			Log.traceText( "Step years : " + (_stepJD / JDUtils.DAYS_PER_YEAR) );
//			Log.traceText( "Step JD : " + _stepJD );


			//_div = heightJD / _stepJD;

			//Log.traceText( "_div : " + _div );

//			_div = MoTimeline.me.duration / _stepJD;
//			Log.traceText( "Total divide : " + _div );
			_div = heightJD / _stepJD;
//			Log.traceText( "Height divide : " + _div );

//			var baseDiv:Number = (MoTimeline.me.baseJD - MoTimeline.me.beginJD) / _stepJD;
//			Log.traceText( "Divide before baseJD : " + baseDiv );

			draw();
		}

		/*private function update():void {
		 draw();
		 }*/

		private function draw():void {
//			Log.traceText( "*execute* GridScale.draw" );
//			killChildren();
//			removeChildren();

			var dateGrad:DateGraduation;
			var len:uint = _div + 1;

//			Log.traceText( "_offsetJD > _stepJD : " + _offsetJD + " > " + _stepJD + " = " + (_offsetJD > _stepJD) );
//			Log.traceText( "_offsetJD : " + _offsetJD );
//			Log.traceText( "_stepJD : " + _stepJD );

//			if ( Math.abs( _offsetJD ) >= _stepJD ) {
//				_offsetJD = Calc.sign( _offsetJD ) * ( Math.abs( _offsetJD ) - _stepJD );
//			}

			var minY:Number = _yCenter - MoTimeline.me.scale * int( len / 2 ) * _stepJD;
			var maxY:Number = _yCenter + MoTimeline.me.scale * int( len / 2 ) * _stepJD;
//			Log.traceText( "    minY, maxY : " + minY + ", " + maxY );

			for ( var i:int = 0; i <= len; i++ ) {
				var jdi:Number = ( -int( len / 2 ) + i ) * _stepJD - _offsetJD;
				var yy:Number = _yCenter + MoTimeline.me.scale * ( jdi );
				var jd:Number = MoTimeline.me.baseJD + jdi;

				dateGrad = _displayed[jd];

				if( !dateGrad ) {
					if( _pool.length ) {
						Log.traceText( "=== Get from Pool : " + JDUtils.getFormatString( jd ) );
						dateGrad = _pool.pop();
						dateGrad.jd = jd;
					} else {
						Log.traceText( "+++ Create new : " + JDUtils.getFormatString( jd ) );
						dateGrad = new DateGraduation( jd, _width ).init();
					}

					if( !contains( dateGrad ) ) {
						addChild( dateGrad );
					}

					_displayed[jd] = dateGrad;
				} else {
					if ( (yy <= minY ) || ( yy >= maxY ) ) {
						Log.traceText( "--- Remove : " + JDUtils.getFormatString( jd ) );

						_pool.push( dateGrad );
						removeChild( dateGrad );
						delete _displayed[jd];
					} else {
						dateGrad.y = yy;
					}
				}


//				if ( (yy > (_yCenter - 10)) && ( yy < ( _yCenter + 10 ) ) ) {
//					dateGrad.kill();
//				} else {
//					addChild( dateGrad );
//					dateGrad.y = yy;
//				}


			}

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

			draw();
		}

	}

}