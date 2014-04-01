package controllers {
	import collections.BondsManager;
	import data.MoBond;
	import data.MoDate;
	import data.MoFact;
	import data.MoTimeline;
	import display.objects.Bond;
	import display.objects.Entity;
	import display.objects.Fact;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BondsRender {
		public var onRenderComplete:Function;
		
		private var _host:ASprite;
		private var _width:Number;
		private var _height:Number;
		
		private var _mapVisibleBonds:Dictionary /*Dictionary*/; // MoFact.id = { MoBond = Bond };
		private var _visibleBonds:Dictionary /*Bond*/; // MoBond = Bond;
		private var _cacheBonds:Dictionary /*Bond*/; // MoBond = Bond;
		
		private var _rgBeginJD:Number;
		private var _rgEndJD:Number;
		private var _scale:Number;
		private var _isResize:Boolean;
		private var _oldDuration:Number;
		
		public function BondsRender( host:ASprite, bounds:Rectangle ) {
			_host = host;
			_width = bounds.width;
			_height = bounds.height;
		}
		
		public function start():void {
			_visibleBonds = new Dictionary( true );
			_cacheBonds = new Dictionary( true );
			_mapVisibleBonds = new Dictionary( true );
			
			
			
			//updateScale();
			//updateVisibleBonds();
			
			//MoTimeline.me.eventManager.addEventListener( TimelineEvent.TIMELINE_RESIZE, onResizeTimeline );
			//MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_RESIZE, onResizeRange );
			//MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_MOVE, onMoveRange );
		}
		
		public function render():void {
			_rgBeginJD = MoTimeline.me.rangeBegin.jd;
			_rgEndJD = MoTimeline.me.rangeEnd.jd;
			
			updateScale();
			updateVisibleBonds();
		}
		
		private function onResizeTimeline( ev:Event ):void {
			//Log.traceText( "*execute* BondsRender.onResizeTimeline" );
			
			updateScale();
			updateVisibleBonds();
		}
		
		private function onResizeRange( ev:Event ):void {
			//Log.traceText( "*execute* BondsRender.onResizeRange" );
			updateScale();
			updateVisibleBonds();
		}
		
		private function onMoveRange( ev:Event ):void {
			//Log.traceText( "*execute* BondsRender.onMoveRange" );
			updateVisibleBonds();
		}
		
		private function updateScale():void {
			var newDuration:Number = _rgEndJD - _rgBeginJD;
			
			_scale = _height / ( newDuration == 0 ? 1 : newDuration );
			
			_isResize = ( _oldDuration != newDuration );
			
			_oldDuration = newDuration;
		}
		
		private function updateVisibleBonds():void {
			var countEnts:int = Math.max( 0, _host.numChildren - 1 );
			
			//Log.traceText( "1 countEnts : " + countEnts );
			
			var ent:Entity;
			var ent1:Entity;
			var ent2:Entity;
			
			var listVisibleMoFacts:Dictionary;
			var listMoBonds:Vector.<MoBond>;
			var bond:Bond;
			var moBond:MoBond;
			var newVisibleBonds:Dictionary = new Dictionary( true );
			var fact:Fact;
			var moFact:MoFact;
			
			// Цикл по сущностям
			while ( countEnts-- ) {
				//Log.traceText( "2 countEnts : " + countEnts );
				ent = _host.getChildAt( countEnts ) as Entity;
				
				if ( ent ) {
					listVisibleMoFacts = ent.getVisibleMapFacts();
					
					for each ( bond in _visibleBonds ) {
						var isRemove:Boolean = listVisibleMoFacts[bond.moBond.id] == undefined;
						
						if ( isRemove ) {
							_host.removeChild( bond );
							delete _visibleBonds[ bond.moBond ];
							countEnts--;
						}
					}
					
					// Цикл по событиям текущей сущности
					for each ( moFact in listVisibleMoFacts ) {
						// Достаём список связей по текущему событию
						listMoBonds = BondsManager.getItems( moFact.id );
						
						// Если связей нет - пропускаем дальнейшие операции
						if ( !listMoBonds ) continue;
						
						var countBonds:int = listMoBonds.length;
						var sumBonds:int = listMoBonds.length;
						
						// Цикл по связям текущего события
						while ( countBonds-- ) {
							moBond = listMoBonds[ countBonds ];
							
							ent1 = _host.getChildByName( "ent_" + moBond.entityUid1 ) as Entity;
							ent2 = _host.getChildByName( "ent_" + moBond.entityUid2 ) as Entity;
							
							if ( !ent1 || !ent2 ) continue;
							
							var widthBond:Number = ent2.x - ent1.x - Settings.ENT_WIDTH;
							var heightBond:Number = _scale * moFact.period.duration;
							
							// Берём изображение из кэша
							bond = _cacheBonds[ moBond ];
							
							// Если в кэше нет - создаём новое изображение
							if ( !bond ) {
								bond = new Bond( moBond, countBonds + 1, sumBonds, widthBond, heightBond ).init();
								_cacheBonds[ moBond ] = bond;
							} else if ( _isResize ) {
								bond.setSize( widthBond, heightBond );
							}
							
							bond.x = ent1.x + Settings.ENT_WIDTH;
							bond.y = dateToY( moFact.period.dateBegin.jd );
							
							if ( !_host.contains( bond ) ) {
								_host.addChildAt( bond, 0 );
								_visibleBonds[ moBond ] = bond;
								
								//if ( !_mapVisibleBonds[ moFact.id ] ) {
									//_mapVisibleBonds[ moFact.id ] = new Dictionary( true );
								//}
								//_mapVisibleBonds[ moFact.id ][ moBond ] = bond;
							}
							//Log.traceText( "Add to visible moBond : " + moBond );
						} // while end
					} // for-each end
					
					// Удаляем связи, которые не соответствуют отображаемым событиям
					//var isRemove:Boolean;
					/*
					var displayBonds:Dictionary = _mapVisibleBonds[ moFact.id ];
					for each ( bond in displayBonds ) {
						isRemove = true;
						for each ( moFact in listVisibleMoFacts ) {
							if ( bond.moBond.id == moFact.id ) {
								isRemove = false;
								break;
							}
						}
						
						if ( isRemove ) {
							_host.removeChild( bond );
							delete _mapVisibleBonds[ moFact.id ][ moBond ];
							countEnts--;
						}
					}
					*/
					
				} // if end
			} // while end
			
			if ( onRenderComplete != null ) {
				if ( onRenderComplete.length ) {
					onRenderComplete( {} );
				} else {
					onRenderComplete();
				}
			}
		}
		
		private function dateToY( date:Number ):Number {
			return _scale * ( date - _rgBeginJD );
		}
		
		public function dispose():void {
			onRenderComplete = null;
		}
	}

}