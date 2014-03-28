package controllers {
	import collections.EntityManager;
	import data.MoDate;
	import data.MoEntity;
	import data.MoTimeline;
	import display.objects.Entity;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntitiesRender {
		
		public var onRenderComplete:Function;
		
		private var _host:ASprite;
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		private var _rgBegin:MoDate;
		private var _rgEnd:MoDate;
		
		private var _mapEntities:Dictionary/*Entity*/; // MoEntity.id = Entity
		private var _mapDisplayEntities:Dictionary/*MoEntity*/; // MoEntity.id = MoEntity
		private var _mapTitles:Dictionary/*TitleEntity*/; // MoEntity.id = TitleEntity
		
		private var _scale:Number = 1;
		private var _space:Number = 0;
		private var _oldDuration:Number = 0;
		private var _isResize:Boolean;
		
		public function EntitiesRender( host:ASprite, bounds:Rectangle ) {
			_host = host;
			_width = bounds.width;
			_height = bounds.height;
		}
		
		public function start():void {
			_mapDisplayEntities = new Dictionary( true );
			_mapEntities = new Dictionary( true );
			_mapTitles = new Dictionary( true );
		}
		
		public function render():void {
			_rgBegin = MoTimeline.me.rangeBegin;
			_rgEnd = MoTimeline.me.rangeEnd;
			
			var newDuration:Number = _rgEnd.jd - _rgBegin.jd;
			_scale = _height / ( newDuration == 0 ? 1 : newDuration );
			_isResize = ( _oldDuration != newDuration );
			_oldDuration = newDuration;
			
			_space = _width / ( EntityManager.length + 1 );
			
			
			var moEnt:MoEntity;
			var ent:Entity;
			
			// Удаляем видимые, но отсутствующие в списке моделей
			for each ( ent in _mapEntities ) {
				moEnt = ent.moEntity;
				
				if ( !EntityManager.hasItem( moEnt.id ) ) {
					//Log.traceText( "xxx Kill entity : " + moEnt.id );
					
					delete _mapEntities[ moEnt.id ];
					ent.kill();
				}
			}
			
			// Отображаем новые, из списка моделей
			for each ( moEnt in EntityManager.mapMoEntities ) {
				if ( !_mapEntities[ moEnt.id ] ) {
					//Log.traceText( "+++ Add new entity : " + moEnt.id );
					ent = new Entity( moEnt ).init();
					_mapEntities[ moEnt.id ] = ent;
				}
			}
			
			var count:uint; // Счётчик сущностей
			
			// Позиционируем и отображаем
			for each ( ent in _mapEntities ) {
				moEnt = ent.moEntity;
				
				if ( ( moEnt.endPeriod.dateBegin.jd > _rgBegin.jd ) && ( moEnt.beginPeriod.dateEnd.jd < _rgEnd.jd ) ) {
					ent.y = dateToY( moEnt.beginPeriod.dateBegin.jd );
					if ( _isResize ) ent.height = moEnt.duration * _scale;
				
					if ( !_host.contains( ent ) ) {
						//Log.traceText( "*** Display entity : " + moEnt.id );
						
						_mapDisplayEntities[ moEnt.id ] = moEnt;
						
						ent.x = calcX( count );
						_host.addChild( ent );
					}
				} else {
					if ( _host.contains( ent ) ) {
						//Log.traceText( "--- Remove entity : " + moEnt.id );
						
						delete _mapDisplayEntities[ moEnt.id ];
						
						_host.removeChild( ent );
					}
				}
				
				count++;
			}
			
			
			if ( onRenderComplete != null ) {
				if ( onRenderComplete.length ) {
					onRenderComplete( {} );
				} else {
					onRenderComplete();
				}
			}
		}
		
		private function calcX( num:uint ):Number {
			return _space + num * _space;
		}
		
		private function dateToY( date:Number ):Number {
			return _scale * ( date - _rgBegin.jd );
		}
		
		public function getDisplayedMoEntities():Dictionary/*MoEntity*/ {
			return _mapDisplayEntities;
		}
		
		public function dispose():void {
			onRenderComplete = null;
			
			_host = null;
			_mapDisplayEntities = null;
			_mapEntities = null;
			_mapTitles = null;
			
			_rgBegin = null;
			_rgEnd = null;
		}
		
	}

}