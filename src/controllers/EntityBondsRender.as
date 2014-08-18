package controllers {
	import collections.BondsManager;
	import collections.EntityManager;

	import com.adobe.utils.DictionaryUtil;

	import data.MoBond;
	import data.MoEntity;
	import data.MoFact;
	import data.MoTimeline;

	import display.objects.Bond;
	import display.objects.Entity;
	import display.objects.Fact;

	import events.TimelineEvent;

	import flash.events.Event;
	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author ...
	 */
	public class EntityBondsRender {
		
		private var _visibleBonds:Dictionary /*Bond*/; // MoBond = Bond;
		private var _cacheBonds:Dictionary /*Bond*/; // MoBond = Bond;
		
		private var _mapVisibleBonds:Dictionary /*Dictionary*/; // MoBond:Bond;
		private var _mapDisplayBonds:Dictionary /*Dictionary*/; // MoEntity.id:{ MoBond:Bond };

		private var _host:ASprite;
		private var _width:Number;
		private var _height:Number;
		private var _scale:Number;
		private var _isResize:Boolean;
		private var _oldDuration:Number;
		
		private var _minJD:Number;
		private var _maxJD:Number;
		private var _yCenter:Number;
		
		public function EntityBondsRender( host:ASprite ) {
			_host = host;
			_width = width;
			_height = height;
			_yCenter = height / 2;
		}
		
		public function init():void {
			_visibleBonds = new Dictionary( true );
			_cacheBonds = new Dictionary( true );
			_mapVisibleBonds = new Dictionary( true );
			_mapDisplayBonds = new Dictionary( true );

			var dh:Number = Display.stageHeight - Settings.TOOLBAR_HEIGHT;
			_minJD = MoTimeline.me.baseJD - dh / MoTimeline.me.scale;
			_maxJD = MoTimeline.me.baseJD + dh / MoTimeline.me.scale;
			
			updateScale();
//			updateVisibleBonds();
			
//			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
//			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onResizeRange );
//			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onMoveRange );
		}
		
		private function onResizeTimeline( ev:Event ):void {
			//Log.traceText( "*execute* BondsRender.onResizeTimeline" );
			
//			update();
		}
		
		public function update( mapVisibleFacts:Dictionary ):void {

			// Проверяем и удаляем из видимых устаревшие связи
			var listIdEnts:Array = DictionaryUtil.getKeys( _mapDisplayBonds );
			var numEnts:uint = listIdEnts.length;
			var idEnt:String;
			var idFact:String;
			var mapFacts:Dictionary;
			var mapBonds:Dictionary;
			var bond:Bond;
			var i:int;


			for ( i = 0; i < numEnts; i++ ) {
				idEnt = listIdEnts[i];

				if ( !mapVisibleFacts[ idEnt ] ) {
					mapBonds = _mapDisplayBonds[ idEnt ];
					for each ( idFact in mapBonds ) {
						bond = mapBonds[ idFact ];
						if ( bond ) {
							Log.traceText( "\t xxx Kill Bond : " + idFact + " / " + bond.moBond.id );
							bond.kill();
							delete mapBonds[idFact];
						}
					}
					delete _mapDisplayBonds[ idEnt ];
					Log.traceText( "xxx Remove dict for entity " + idEnt );
				}
			}


			updateScale();
//			updateVisibleBonds();
			
			// mapVisibleFacts = { MoEntity.id: { MoFact.id: Fact } }
//			Log.traceText( "*execute* BondsRender.update" );
			
			listIdEnts = DictionaryUtil.getKeys( mapVisibleFacts );
			numEnts = listIdEnts.length;
//			Log.traceText( "numEnts : " + numEnts );

			for ( i = 0; i < numEnts; i++ ) {
				idEnt = listIdEnts[i];

				if( !_mapDisplayBonds[ idEnt ] ){
					_mapDisplayBonds[ idEnt ] = new Dictionary(true);
					Log.traceText( "Add dict for entity " + idEnt );
				}

				mapFacts = mapVisibleFacts[idEnt];
				var listIdFacts:Array = DictionaryUtil.getKeys( mapFacts );
//				var numFacts:uint = listIdFacts.length;
//				Log.traceText( idEnt + " - numFacts : " + numFacts );
				
				for ( var j:int = 0; j < listIdFacts.length; j++ ) {
					idFact = listIdFacts[j];
					var fact:Fact = mapFacts[idFact];
					var listMoBonds:Vector.<MoBond> = BondsManager.getItems( idFact );

					// Если связей нет - пропускаем дальнейшие операции
					if ( !listMoBonds ) continue;
//					trace("listMoBonds : " + listMoBonds);
					
					var numBonds:uint = listMoBonds.length;
					for ( var k:int = 0; k < numBonds; k++ ) {
						var moBond:MoBond = listMoBonds[k];
						
						var ent1:MoEntity = EntityManager.getItem( moBond.entityUid1 );
						var ent2:MoEntity = EntityManager.getItem( moBond.entityUid2 );
						
						if ( !ent1 || !ent2 ) continue;
						
//						Log.traceText( "ent1.xView : " + ent1.xView );

						var x1:Number = Math.min( ent1.xView, ent2.xView );
						var x2:Number = Math.max( ent1.xView, ent2.xView );

						var widthBond:Number = x2 - x1 - Settings.ENT_WIDTH;
						var heightBond:Number = _scale * fact.moFact.period.duration;



//						var bond:Bond = _mapVisibleBonds[ moBond.id ];
						bond = _mapDisplayBonds[ idEnt ][ moBond.id ];


						if ( !bond ) {
							bond = new Bond( moBond, k, numBonds, widthBond, heightBond ).init();
							_host.addChild( bond );
//							_mapVisibleBonds[ moBond.id ] = bond;
							_mapDisplayBonds[ idEnt ][ moBond.id ] = bond;
							Log.traceText( "\tAdd to entity " + idEnt + " bond " + moBond.id );
						}

						if ( bond ) {
//							Log.traceText( "heightBond : " + heightBond );

							bond.setSize( widthBond, heightBond );
							bond.x = x1 + Settings.ENT_WIDTH;
		//					bond.y = dateToY( fact.moFact.period.beginJD );
							bond.y = getY( fact.moFact );
						}


//						Log.traceText( "bond.x, y : " + bond.x + ", " + bond.y );
//						Log.traceText( "bond.width, height : " + bond.width + ", " + bond.height );
					}
					
//					var bond:Bond = new Bond( moBond, countBonds + 1, sumBonds, widthBond, heightBond ).init();
				}
			}
			
//			updateScale();
//			updateVisibleBonds();
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
			var newDuration:Number = _maxJD - _minJD;
			
			_scale = MoTimeline.me.scale;
			
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
						//isRemove = listVisibleMoFacts[moFact.id] == undefined;
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
							bond.y = dateToY( moFact.period.beginJD );
							
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
		}
		
		private function dateToY( date:Number ):Number {
			return _scale * ( date - _minJD );
		}

		private function getY( moFact:MoFact ):Number
		{
			return Math.max( 0, _yCenter + MoTimeline.me.scale * ( moFact.period.beginJD - MoTimeline.me.baseJD ) );
		}
		
		public function dispose():void {
//			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onResizeRange );
//			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onMoveRange );
			
			_visibleBonds = null;
			_mapVisibleBonds = null;
			_cacheBonds = null;
			
			_host = null;
		}
	}

}