package display.objects {

	import collections.EntityColor;
	import data.MoDate;
	import data.MoEntity;
	import data.MoFact;
	import data.MoTimeline;
	import flash.utils.Dictionary;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * Сущность хроноленты
	 * @author Artem Arslanov
	 */
	public class Entity extends ASprite {

		static private var _freeFacts:Vector.<Fact> = new Vector.<Fact>(); // Кэш вьюшек событий

		private var _visibleMoFacts:Vector.<MoFact> = new Vector.<MoFact>(); // Список отображаемых событий
		private var _mapVisibleMoFacts:Dictionary/*MoFact*/ = new Dictionary( true ); // список элементов для отображения MoFact.id = MoFact

		private var _displayedFacts:Dictionary /*MoFact*/ = new Dictionary( true ); // MoFact = Fact
		private var _removeMoFacts:Vector.<MoFact> = new Vector.<MoFact>();
		private var _moEntity:MoEntity;
		private var _hostFacts:ASprite;
		private var _body:EntityView;
		private var _scale:Number;
		private var _rangeBegin:MoDate;
		private var _rangeEnd:MoDate;

		private var _isUpdating:Boolean;
		private var _stepDate:Number;

		public function Entity( moEntity:MoEntity ) {
			_moEntity = moEntity;

			this.name = "ent_" + moEntity.id;

			super();
		}

		override public function init():* {
			super.init();
			
			_rangeBegin = MoTimeline.me.rangeBegin;
			_rangeEnd = MoTimeline.me.rangeEnd;

			_body = new EntityView( 1, EntityColor.getColor() ).init();
			_hostFacts = new ASprite().init();
			
			addChild( _body );
			addChild( _hostFacts );



			var firstFact:MoFact = _moEntity.facts[ 0 ];
			_mapVisibleMoFacts[ firstFact.id ] = firstFact;

			var lastFact:MoFact = _moEntity.facts[ Math.max( 0, _moEntity.facts.length - 1 ) ];
			if ( lastFact != firstFact ) {
				_mapVisibleMoFacts[ lastFact.id ] = lastFact;
			}

			return this;
		}

		public function get moEntity():MoEntity {
			return _moEntity;
		}

		override public function set height( value:Number ):void {
			if ( value == _body.height )
				return;

			if ( _isUpdating )
				return;

			_body.height = value;
			_scale = _body.height / _moEntity.duration;

			var div:Number = int(( _body.height + Settings.ICON_SIZE ) / Settings.ICON_SIZE );
			_stepDate = _moEntity.duration / div;

			//Log.traceText( "----------------------------------" );
			//Log.traceText( "_moEntity.duration : " + _moEntity.duration );
			//Log.traceText( "div : " + div );
			//Log.traceText( "_stepDate : " + _stepDate );

			_isUpdating = true;

			//if ( _stepDate >= 0.5 ) {
				_num = 0;

				//_visibleMoFacts.length = 0;
				//_visibleMoFacts.push( _moEntity.facts[ 0 ] );
				//_visibleMoFacts.push( _moEntity.facts[ Math.max( 0, _moEntity.facts.length - 1 ) ] );
				getMiddleValue( _moEntity.facts[ 0 ], _moEntity.facts[ Math.max( 0, _moEntity.facts.length - 1 ) ] );
			//}

			//Log.traceText( "_num : " + _num );

			//updateVisibleMoFacts();
			updateDisplayFacts();

			_isUpdating = false;
		}
		//} endregion

		/***************************************************************************
		   Обновление
		 ***************************************************************************/
		// Выполняем при изменении масштаба (временного диапазона)
		// Составляем список событий, видимых в текущем масштабе

		private var _num:uint;

		private function getMiddleValue( item1:MoFact, item2:MoFact ):void {
			_num++;

			//Log.traceText( "----------------------------------" );
			//Log.traceText( "Iteration : " + _num );

			//if ( _num > moEntity.facts.length ) {
				//Log.traceText( "Break circle!!!!" );
				//return;
			//}

			var idx1:int = moEntity.facts.indexOf( item1 ); // Индекс первого элемента
			var idx2:int = moEntity.facts.indexOf( item2 ); // Индекс второго элемента

			//Log.traceText( "Indexes idx1 - idx2 : " + idx1 + " - " + idx2 );
			if (( idx2 - idx1 ) <= 1 )
				return;

			//Log.traceText( "Item 1 date : " + item1.period.middle );
			//Log.traceText( "Item 2 date : " + item2.period.middle );

			//var deltaDates:Number = item2.period.middle - item1.period.middle;

			//Log.traceText( "Delta dates > 2 * step date : " + deltaDates + " > " + (2 * _stepDate) );

			//if ( deltaDates < ( 2 * _stepDate ) )
			//if ( deltaDates < _stepDate )
				//return;

			var midIndex:int = Math.floor(( idx1 + idx2 ) / 2 ); // Индекс элемента, максимально приближённого к середине

			//Log.traceText( "Middle index : " + midIndex );

			var midFact:MoFact = moEntity.facts[ midIndex ]; // Элемент по среднему индексу

			//Log.traceText( "Middle item date : " + midFact.period.middle );

			var deltaDate1:Number = midFact.period.middle - item1.period.middle;
			var deltaDate2:Number = item2.period.middle - midFact.period.middle;

			//Log.traceText( "deltaDate1 : " + deltaDate1 );
			//Log.traceText( "deltaDate2 : " + deltaDate2 );

			// Разность дат выше и ниже события больше шага, то отображаем событие
			if (( deltaDate1 > _stepDate ) && ( deltaDate2 > _stepDate ) ) {
				if ( !_mapVisibleMoFacts[ midFact.id ] ) {
					_mapVisibleMoFacts[ midFact.id ] = midFact;
					//Log.traceText( "\tAdd fact : " + midIndex + " - " + midFact );
				}
			} else {
				if ( _mapVisibleMoFacts[ midFact.id ] ) {
					delete _mapVisibleMoFacts[ midFact.id ];
					//Log.traceText( "\tRemove fact : " + midIndex + " - " + midFact );
				}
			}

			//if ( ( midFact.period.middle < _rangeEnd.jd ) && ( item1.period.middle < _rangeEnd.jd ) && ( deltaDate1 > _stepDate ) ) {
				//getMiddleValue( item1, midFact );
			//}
			//
			//if ( ( midFact.period.middle > _rangeBegin.jd ) && ( item2.period.middle > _rangeBegin.jd ) && ( deltaDate2 > _stepDate ) ) {
				//getMiddleValue( midFact, item2 );
			//}

			if ( ( item2.period.middle < _rangeBegin.jd ) || ( item1.period.middle > _rangeEnd.jd ) ) {
				return;
			}

			if ( deltaDate1 > _stepDate ) {
				getMiddleValue( item1, midFact );
			}

			if ( deltaDate2 > _stepDate ) {
				getMiddleValue( midFact, item2 );
			}
		}

		public function updateDisplayFacts():void {
			var fact:Fact;
			var moFact:MoFact;
			var factY:Number;
			var factHeight:Number;

			//Log.traceText( "_removeMoFacts.length : " + _removeMoFacts.length );

			for each ( fact in _displayedFacts ) {
				if ( !_mapVisibleMoFacts[ fact.moFact.id ] ) {
					fact = getFreeFact( fact.moFact );
					if ( fact ) {
						//Log.traceText( "--- Remove" );
						_hostFacts.removeChild( fact );
					}
				}
			}

			for each ( moFact in _mapVisibleMoFacts ) {
				// Если событие не входит в диапазон...
				//if (( moFact.period.dateBegin.jd > _rangeBegin.jd ) && ( moFact.period.dateEnd.jd < _rangeEnd.jd ) ) {
				if (( moFact.period.middle > _rangeBegin.jd ) && ( moFact.period.middle < _rangeEnd.jd ) ) {
					fact = getDisplayFact( moFact );

					factHeight = Math.max( 1, moFact.period.duration * _scale );
					factY = dateToY( moFact.period.dateBegin.jd );

					if ( !_hostFacts.contains( fact ) ) {
						fact.initialize( moFact, factHeight );

						_hostFacts.addChild( fact );
						//Log.traceText( "+++ draw " + moFact );
					} else {
						fact.height = factHeight;
					}

					fact.y = factY;
				} else {
					// Удаляем событие за пределами диапазона
					fact = getFreeFact( moFact );
					if ( fact ) {
						//delete _mapVisibleMoFacts[ moFact.id ];
						_hostFacts.removeChild( fact );
						//Log.traceText( "--- remove " + moFact );
					}
				}
			}
		}

		private function getDisplayFact( moFact:MoFact ):Fact {
			var fact:Fact = _displayedFacts[ moFact ];

			if ( !fact ) {
				fact = _freeFacts.shift();

				if ( !fact ) {
					fact = new Fact().init();
				}

				_displayedFacts[ moFact ] = fact;
			}

			return fact;
		}

		private function getFreeFact( moFact:MoFact ):Fact {
			var fact:Fact = _displayedFacts[ moFact ];

			if ( fact ) {
				_freeFacts.push( fact.setFree() );
				delete _displayedFacts[ moFact ];
			}

			return fact;
		}

		//} endregion

		public function get body():EntityView {
			return _body;
		}

		public function getVisibleFacts():Dictionary /*Fact*/ {
			return _displayedFacts;
		}

		public function getVisibleMoFacts():Vector.<MoFact> {
			return _visibleMoFacts;
		}

		public function getVisibleMapFacts():Dictionary {
			return _mapVisibleMoFacts;
		}

		private function dateToY( value:Number ):Number {
			return ( value - moEntity.beginPeriod.dateBegin.jd ) * _scale;
		}

		override public function kill():void {
			super.kill();

			_visibleMoFacts = null;
			_displayedFacts = null;
			_mapVisibleMoFacts = null;
			_removeMoFacts.length = 0;

			_rangeBegin = null;
			_rangeEnd = null;
			_moEntity = null;
		}
	}

}
