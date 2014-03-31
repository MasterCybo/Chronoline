package controllers {
	import collections.EntityManager;
	import data.MoDate;
	import data.MoEntity;
	import data.MoTimeline;
	import display.components.TitleEntity;
	import display.objects.Entity;
	import events.TimelineEvent;
	import flash.utils.Dictionary;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntitiesRender {
		
		private var _host:ASprite;
		
		private var _listMoEntities:Vector.<MoEntity>;
		private var _mapEntities:Dictionary /*Entity*/; // MoEntity.id = Entity
		private var _mapTitles:Dictionary /*TitleEntity*/; // MoEntity.id = TitleEntity
		
		private var _scale:Number = 1;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _space:Number = 0;
		private var _oldDuration:Number = 0;
		private var _isResize:Boolean;
		
		private var _rgBegin:MoDate;
		private var _rgEnd:MoDate;
		
		public function EntitiesRender( host:ASprite, width:Number, height:Number ) {
			_host = host;
			_width = width;
			_height = height;
		}
		
		public function init():void {
			_rgBegin = MoTimeline.me.rangeBegin;
			_rgEnd = MoTimeline.me.rangeEnd;
			
			_listMoEntities = new Vector.<MoEntity>();
			
			//MoTimeline.me.eventManager.addEventListener( TimelineEvent.TIMELINE_RESIZE, onResizeTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_RESIZE, onResizeRange );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_MOVE, onMoveRange );
		}
		
		private function onResizeTimeline( ev:TimelineEvent ):void {
			update();
		}
		
		public function update():void {
			updateListMoEntities();
			updateScale();
			updateSizeAndPositions();
		}
		
		private function onResizeRange( ev:TimelineEvent ):void {
			//Log.traceText( "*execute* EntitiesRender.onResizeRange" );
			
			updateScale();
			updateSizeAndPositions();
		}
		
		private function onMoveRange( ev:TimelineEvent ):void {
			//Log.traceText( "*execute* EntitiesRender.onMoveRange" );
			
			updateSizeAndPositions();
		}
		
		/**
		 * Обновляем список отображаемых сущностей
		 * Обновляется при инициализации и по событию изменения MoTimeline
		 */
		private function updateListMoEntities():void {
			_listMoEntities = Vector.<MoEntity>( EntityManager.getArrayEntities() );
			
			_mapEntities = new Dictionary( true );
			_mapTitles = new Dictionary( true );
			
			var moEnt:MoEntity;
			var ent:Entity;
			var title:TitleEntity;
			var len:uint = _listMoEntities.length;
			
			for ( var i:int = 0; i < len; i++ ) {
				moEnt = _listMoEntities[ i ];
				
				ent = new Entity( moEnt ).init();
				title = new TitleEntity( moEnt.title ).init();
				
				_mapEntities[ moEnt.id ] = ent;
				_mapTitles[ moEnt.id ] = title;
				
				//Log.traceText( "ent.name : " + ent.name );
			}
			
			_space = _width / ( len + 1 );
		}
		
		private function updateScale():void {
			var newDuration:Number = _rgEnd.jd - _rgBegin.jd;
			
			_scale = _height / ( newDuration == 0 ? 1 : newDuration );
			
			_isResize = ( _oldDuration != newDuration );
			
			_oldDuration = newDuration;
		}
		
		/**
		 * Обновляем положение и размеры
		 */
		private function updateSizeAndPositions():void {
			var len:uint = _listMoEntities.length;
			var moEnt:MoEntity;
			var ent:Entity;
			var title:TitleEntity;
			
			//Perf.start();
			
			for ( var i:int = 0; i < len; i++ ) {
				moEnt = _listMoEntities[ i ];
				ent = _mapEntities[ moEnt.id ];
				title = _mapTitles[ moEnt.id ];
				
				// Если сущность не входит в диапазон...
				if (( moEnt.endPeriod.dateEnd.jd < _rgBegin.jd ) || ( moEnt.beginPeriod.dateBegin.jd > _rgEnd.jd ) ) {
					// ... и если отображается, тогда удаляем её
					if ( _host.contains( ent ) ) {
						//Log.traceText( "---------- removeChild" );
						_host.removeChild( ent );
						_host.removeChild( title );
					}
				} else {
					// ... если входит в диапазон и не отображается, тогда отображаем её
					ent.y = dateToY( moEnt.beginPeriod.dateBegin.jd );
					
					// Если размер диапазона был изменён, то меняем размер сущностей
					if ( _isResize ) {
						ent.height = moEnt.duration * _scale;
					}
					
					if ( !_host.contains( ent ) ) {
						//Log.traceText( "++++++++++ addChild" );
						
						ent.x = calcX( i );
						ent.height = moEnt.duration * _scale;
						
						_host.addChild( title );
						_host.addChild( ent );
					}
					
					ent.updateDisplayFacts();
				}
				
				if ( _host.contains( title ) ) {
					title.x = ent.x + ent.body.width;
					title.y = Math.max( ent.y, ent.y + ent.height - ( ent.height + ent.y ) );
				}
				
			}
			
			//Log.traceText( "Entities draw complete" );
			
			//Log.traceText( "Perf.stop() : " + Perf.stop() );
		}
		
		private function calcX( num:uint ):Number {
			return _space + num * _space;
		}
		
		private function dateToY( date:Number ):Number {
			return _scale * ( date - _rgBegin.jd );
		}
		
		public function dispose():void {
			//MoTimeline.me.eventManager.removeEventListener( TimelineEvent.TIMELINE_RESIZE, onResizeTimeline );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.RANGE_RESIZE, onResizeRange );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.RANGE_MOVE, onMoveRange );
			
			_host = null;
			_listMoEntities = null;
			_mapEntities = null;
			_mapTitles = null;
			_rgBegin = null;
			_rgEnd = null;
		}
	}

}