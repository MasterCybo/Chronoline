package controllers {
	import data.MoDate;
	import data.MoEntity;
	import data.MoFact;
	import data.MoTimeline;
	import display.objects.Fact;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import ru.arslanov.flash.display.ASprite;
	/**
	* ...
	* @author Artem Arslanov
	*/
	public class FactsRender {
		
		static private var _freeFacts:Vector.<Fact> = new Vector.<Fact>(); // Кэш вьюшек событий
		
		
		public var onRenderComplete:Function;
		
		private var _host:ASprite;
		private var _width:Number;
		private var _height:Number;
		
		
		private var _visibleMoFacts:Vector.<MoFact> = new Vector.<MoFact>(); // Список отображаемых событий
		private var _mapVisibleMoFacts:Dictionary/*MoFact*/ = new Dictionary( true ); // список элементов для отображения MoFact.id = MoFact
		private var _displayedFacts:Dictionary/*MoFact*/ = new Dictionary( true ); // MoFact = Fact
		private var _removeMoFacts:Vector.<MoFact> = new Vector.<MoFact>();
		
		
		private var _mapDisplayedFacts:Dictionary/*Dictionary*/; // MoEntity.id = { MoFact.id = Fact }
		
		
		private var _rgBegin:MoDate;
		private var _rgEnd:MoDate;
		
		private var _scale:Number = 1;
		private var _stepDate:Number;
		private var _oldDuration:Number;
		
		
		public function FactsRender( host:ASprite, bounds:Rectangle ) {
			_host = host;
			_width = bounds.width;
			_height = bounds.height;
		}
		
		public function start():void {
			_mapDisplayedFacts = new Dictionary( true );
			
			_rgBegin = MoTimeline.me.rangeBegin;
			_rgEnd = MoTimeline.me.rangeEnd;
		}
		
		public function render( mapDisplayMoEntities:Dictionary/*MoEntity*/ ):void {
			var newDuration:Number = _rgEnd.jd - _rgBegin.jd;
			_scale = _height / ( newDuration == 0 ? 1 : newDuration );
			_oldDuration = newDuration;
			
			var moEnt:MoEntity;
			var mapMoFacts:Dictionary;
			
			// Удаляем события, которых нет в карте событий
			for each ( mapMoFacts in _mapDisplayedFacts ) {
				
			}
			
			
			var entHeight:Number;
			
			for each ( moEnt in mapDisplayMoEntities ) {
				entHeight = moEnt.duration * _scale;
				var div:Number = int(( entHeight + Settings.ICON_SIZE ) / Settings.ICON_SIZE );
				_stepDate = moEnt.duration / div;
			}
			
			
			if ( onRenderComplete != null ) {
				if ( onRenderComplete.length ) {
					onRenderComplete( {} );
				} else {
					onRenderComplete();
				}
			}
		}
		
		private var _num:uint;
		
		private function takeMiddle( fact1:MoFact, fact2:MoFact ):void {
			if ( fact1 == fact2 ) return;
			
			var idx1:int = Math.min( _items.indexOf( item1 ), _items.indexOf( item2 ) );
			var idx2:int = Math.max( _items.indexOf( item1 ), _items.indexOf( item2 ) );
			
			_num++;
			
			//Log.traceText( "----------------------------------" );
			//Log.traceText( "Iteration : " + _num );
			
			//if ( _num > moEntity.facts.length ) {
				//Log.traceText( "Break circle!!!!" );
				//return;
			//}
			
			var moEntity:MoEntity; // FAKE!!!!!! Удалить
			
			var idx1:int = moEntity.facts.indexOf( fact1 ); // Индекс первого элемента
			var idx2:int = moEntity.facts.indexOf( fact2 ); // Индекс второго элемента
			
			//Log.traceText( "Indexes idx1 - idx2 : " + idx1 + " - " + idx2 );
			if (( idx2 - idx1 ) <= 1 )
				return;
			
			//Log.traceText( "Item 1 date : " + fact1.period.middle );
			//Log.traceText( "Item 2 date : " + fact2.period.middle );
			
			var deltaDates:Number = fact2.period.middle - fact1.period.middle;
			
			//Log.traceText( "Delta dates > 2 * step date : " + deltaDates + " > " + (2 * _stepDate) );
			
			//if ( deltaDates < ( 2 * _stepDate ) )
			if ( deltaDates < _stepDate )
				return;
			
			var midIndex:int = Math.floor(( idx1 + idx2 ) / 2 ); // Индекс элемента, максимально приближённого к середине
			
			//Log.traceText( "Middle index : " + midIndex );
			
			var midFact:MoFact = moEntity.facts[ midIndex ]; // Элемент по среднему индексу
			
			//Log.traceText( "Middle item date : " + midFact.period.middle );
			
			var deltaDate1:Number = midFact.period.middle - fact1.period.middle;
			var deltaDate2:Number = fact2.period.middle - midFact.period.middle;
			
			//Log.traceText( "deltaDate1 : " + deltaDate1 );
			//Log.traceText( "deltaDate2 : " + deltaDate2 );
			
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
			
			if ( ( fact2.period.middle < _rgBegin.jd ) || ( fact1.period.middle > _rgEnd.jd ) ) {
				return;
			}
			
			if ( deltaDate1 > _stepDate ) {
				takeMiddle( fact1, midFact );
			}
			
			if ( deltaDate2 > _stepDate ) {
				takeMiddle( midFact, fact2 );
			}
		}
		
		public function dispose():void {
			onRenderComplete = null;
		}
	}

}