package controllers {
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
		
		
		private var _rgBeginJD:Number;
		private var _rgEndJD:Number;
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
		}
		
		public function render( mapDisplayMoEntities:Dictionary/*MoEntity*/ ):void {
			_rgBeginJD = MoTimeline.me.rangeBegin.jd;
			_rgEndJD = MoTimeline.me.rangeEnd.jd;
			
			var newDuration:Number = _rgEndJD - _rgBeginJD;
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
		
		private function getMiddleValue( item1:MoFact, item2:MoFact ):void {
			_num++;
			
			//Log.traceText( "----------------------------------" );
			//Log.traceText( "Iteration : " + _num );
			
			//if ( _num > moEntity.facts.length ) {
				//Log.traceText( "Break circle!!!!" );
				//return;
			//}
			
			var moEntity:MoEntity; // FAKE!!!!!! Удалить
			
			var idx1:int = moEntity.facts.indexOf( item1 ); // Индекс первого элемента
			var idx2:int = moEntity.facts.indexOf( item2 ); // Индекс второго элемента
			
			//Log.traceText( "Indexes idx1 - idx2 : " + idx1 + " - " + idx2 );
			if (( idx2 - idx1 ) <= 1 )
				return;
			
			//Log.traceText( "Item 1 date : " + item1.period.middle );
			//Log.traceText( "Item 2 date : " + item2.period.middle );
			
			var deltaDates:Number = item2.period.middle - item1.period.middle;
			
			//Log.traceText( "Delta dates > 2 * step date : " + deltaDates + " > " + (2 * _stepDate) );
			
			//if ( deltaDates < ( 2 * _stepDate ) )
			if ( deltaDates < _stepDate )
				return;
			
			var midIndex:int = Math.floor(( idx1 + idx2 ) / 2 ); // Индекс элемента, максимально приближённого к середине
			
			//Log.traceText( "Middle index : " + midIndex );
			
			var midFact:MoFact = moEntity.facts[ midIndex ]; // Элемент по среднему индексу
			
			//Log.traceText( "Middle item date : " + midFact.period.middle );
			
			var deltaDate1:Number = midFact.period.middle - item1.period.middle;
			var deltaDate2:Number = item2.period.middle - midFact.period.middle;
			
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
			
			if ( ( item2.period.middle < _rgBeginJD ) || ( item1.period.middle > _rgEndJD ) ) {
				return;
			}
			
			if ( deltaDate1 > _stepDate ) {
				getMiddleValue( item1, midFact );
			}
			
			if ( deltaDate2 > _stepDate ) {
				getMiddleValue( midFact, item2 );
			}
		}
		
		public function dispose():void {
			onRenderComplete = null;
		}
	}

}