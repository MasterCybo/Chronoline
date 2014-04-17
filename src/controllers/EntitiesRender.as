package controllers {
	import collections.EntityManager;
	import data.MoEntity;
	import data.MoTimeline;
	import display.components.TitleEntity;
	import display.objects.Entity;
	import events.TimelineEvent;
	import flash.utils.Dictionary;
	import ru.arslanov.core.utils.Log;
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
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _space:Number = 0;
		private var _yCenter:Number;
		
		public function EntitiesRender( host:ASprite, width:Number, height:Number ) {
			_host = host;
			_width = width;
			_height = height;
			_yCenter = height / 2;
		}
		
		public function init():void {
			_listMoEntities = new Vector.<MoEntity>();
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onScaleChanged );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onDateChanged );
		}
		
		private function onInitTimeline( ev:TimelineEvent ):void {
			update();
		}
		
		private function onScaleChanged( ev:TimelineEvent ):void {
			updateSizeAndPositions();
		}
		
		private function onDateChanged( ev:TimelineEvent ):void {
			updateSizeAndPositions();
		}
		
		public function update():void {
			updateListMoEntities();
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
				
				ent.y = dateToY( moEnt.beginPeriod.beginJD );
				
				ent.height = moEnt.duration * MoTimeline.me.scale;
				
				if ( _host.contains( ent ) ) {
					if ( (ent.y > _height) || ( (ent.y + ent.height) < 0 ) ) {
						_host.removeChild( ent );
						_host.removeChild( title );
					}
				} else {
					//Log.traceText( "++++++++++ addChild" );
					
					ent.x = calcX( i );
					ent.height = moEnt.duration * MoTimeline.me.scale;
					
					_host.addChild( title );
					_host.addChild( ent );
				}
				
				ent.updateDisplayFacts();
				
				if ( _host.contains( title ) ) {
					title.x = ent.x + ent.body.width;
					title.y = Math.max( ent.y, ent.y + ent.height - ( ent.height + ent.y ) );
				}
				
			}
			
			//Log.traceText( "Entities draw complete" );
			
			//Log.traceText( "Perf.stop() : " + Perf.stop() );
		}
		
		private function calcX( ordinal:uint ):Number {
			return _space + ordinal * _space;
		}
		
		private function dateToY( jd:Number ):Number {
			return _yCenter + MoTimeline.me.scale * ( jd - MoTimeline.me.baseJD );
		}
		
		public function dispose():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onScaleChanged );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onDateChanged );
			
			_host = null;
			_listMoEntities = null;
			_mapEntities = null;
			_mapTitles = null;
		}
	}

}