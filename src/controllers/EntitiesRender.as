package controllers
{
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
	public class EntitiesRender
	{

		private var _host:ASprite;

		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _space:Number = 0; // расстояние между сущностями
		private var _yCenter:Number;

		private var _isScaled:Boolean = false;
		private var _isMoved:Boolean = false;

		// Данные, которые берём из менеджера
		private var _listMoEntities:Vector.<MoEntity>;
		private var _mapMoEntities:Dictionary/*MoEntity*/; // MoEntity.id = MoEntity;

		// Очерёдность отрисовки сущностей
		private var _order:Array = []; // MoEntity.id

		// Генерируемые данные
		private var _mapEntities:Dictionary/*Entity*/ = new Dictionary( true ); // MoEntity.id = Entity
		private var _pool:Dictionary/*Entity*/ = new Dictionary( true ); // MoEntity.id = Entity
		private var _mapTitles:Dictionary/*TitleEntity*/ = new Dictionary( true ); // MoEntity.id = TitleEntity

		public function EntitiesRender( host:ASprite, width:Number, height:Number )
		{
			_host = host;
			_width = width;
			_height = height;
			_yCenter = height / 2;
		}

		public function init():void
		{
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onScaleChanged );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onDateChanged );
		}

		private function onInitTimeline( ev:TimelineEvent ):void
		{
			_mapMoEntities = EntityManager.mapMoEntities;

			var listMoEnts:Array = EntityManager.getArrayEntities();
			_listMoEntities = Vector.<MoEntity>( listMoEnts );

			// Формирование очерёдности отрисовки сущностей
			var order:Array = listMoEnts.concat().sort( compareByDate );

			_order.length = 0;
			var len:uint = order.length;
			for ( var i:int = 0; i < len; i++ ) {
				_order.push( order[i].id );
			}

//			Log.traceText( "_order : " + _order );

			_space = _width / ( _listMoEntities.length + 1 );

			_mapEntities = new Dictionary( true );
			_pool = new Dictionary( true );

//			update();
		}

		/**
		 * Сравнение сущностей по начальной дате
		 * @param a
		 * @param b
		 * @return
		 */
		private function compareByDate( a:MoEntity, b:MoEntity ):Number
		{
			if ( a.beginPeriod.beginJD > b.beginPeriod.beginJD ) return 1;
			if ( a.beginPeriod.beginJD < b.beginPeriod.beginJD ) return -1;
			return 0;
		}

		/**
		 * Сравнение сущностей по продолжительности
		 * @param a
		 * @param b
		 * @return
		 */
		private function compareByDuration( a:MoEntity, b:MoEntity ):Number
		{
			if ( a.duration > b.duration ) return 1;
			if ( a.duration < b.duration ) return -1;
			return 0;
		}

		/**
		 * Сравнение сущностей по ID
		 * @param a
		 * @param b
		 * @return
		 */
		private function compareByID( a:MoEntity, b:MoEntity ):Number
		{
			if ( a.id > b.id ) return 1;
			if ( a.id < b.id ) return -1;
			return 0;
		}

		public function update():void
		{
			render();
		}

		private function onScaleChanged( ev:TimelineEvent ):void
		{
			_isScaled = true;

			render();
		}

		private function onDateChanged( ev:TimelineEvent ):void
		{
			_isMoved = true;

			render();
		}

		/**
		 * Обновляем список отображаемых сущностей
		 */
		private function render():void
		{
			var i:int;
			var moEnt:MoEntity;
			var moEntVis:MoEntity;
			var ent:Entity;
			var title:TitleEntity;

			var listRemoved:Dictionary = new Dictionary( true );

			// Проходимся по видимым - удаляем те, которых нет в списке
			for each ( ent in _mapEntities ) {
				moEntVis = ent.moEntity;

				if ( !_mapMoEntities[ moEntVis.id ] || ( ent.y > _height ) || ( ( ent.y + ent.height ) < 0 ) ) {
					listRemoved[ moEntVis.id ] = ent;

					Log.traceText( "Remove : " + moEntVis.title );
				}
			}

			// добавляем в список отображения новые объекты
			for each ( moEnt in _listMoEntities ) {
				if ( !listRemoved[ moEnt.id ] ) {
					var yy:Number = getY( moEnt.beginPeriod.beginJD );
					var hh:Number = moEnt.duration * MoTimeline.me.scale;
					if ( !_mapEntities[ moEnt.id ] && ( ( ( yy + hh ) >= 0 ) && ( yy < _height ) ) ) {
						ent = _pool[ moEnt.id ];

						if ( ent ) {
							delete _pool[ moEnt.id ];
						} else {
							ent = new Entity( moEnt ).init();
						}
						_mapEntities[ moEnt.id ] = ent;
					}
				}
			}


			for each ( ent in listRemoved ) {
				delete _mapEntities[ ent.moEntity.id ];
				_host.removeChild( ent );
				_pool[ ent.moEntity.id ] = ent;
			}

			for each ( ent in _mapEntities ) {
				moEnt = ent.moEntity;

				if ( _isMoved ) {
					ent.y = getY( moEnt.beginPeriod.beginJD );
				}

				if ( _isScaled ) {
					ent.height = moEnt.duration * MoTimeline.me.scale;
				}

				if ( !_host.contains( ent ) ) {
					ent.x = getX( _order.indexOf( moEnt.id ) );
					ent.y = getY( moEnt.beginPeriod.beginJD );
					ent.height = moEnt.duration * MoTimeline.me.scale;
					_host.addChild( ent );
				}
			}

			_isScaled = false;
			_isMoved = false;
		}

		private function getX( ordinal:uint ):Number
		{
			return _space + ordinal * _space;
		}

		private function getY( jd:Number ):Number
		{
			return _yCenter + MoTimeline.me.scale * ( jd - MoTimeline.me.baseJD );
		}

		public function dispose():void
		{
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