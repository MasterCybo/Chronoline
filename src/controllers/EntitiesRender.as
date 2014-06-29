package controllers
{
	import collections.EntityManager;

	import com.greensock.motionPaths.MotionPath;

	import data.MoEntity;
	import data.MoTimeline;

	import display.components.TitleEntity;
	import display.objects.Entity;

	import events.TimelineEvent;

	import flash.filters.GlowFilter;

	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Calc;

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

		// Данные, которые берём из менеджера
		private var _listMoEntities:Vector.<MoEntity>;
		private var _mapMoEntities:Dictionary/*MoEntity*/; // MoEntity.id = MoEntity;

		// Порядок отображения сущностей
		private var _order:Array = []; // MoEntity.id

		// Генерируемые данные
		private var _mapDisplayEntities:Dictionary/*Entity*/ = new Dictionary( true ); // MoEntity.id = Entity
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
//			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onScaleChanged );
//			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onDateChanged );
		}

		private function onInitTimeline( ev:TimelineEvent ):void
		{
			_mapMoEntities = EntityManager.mapMoEntities;

			var listMoEnts:Array = EntityManager.getArrayEntities();
			_listMoEntities = Vector.<MoEntity>( listMoEnts );

			// Формируем порядок отображения сущностей
			var order:Array = listMoEnts.concat().sort( compareByDate );

			_order.length = 0;
			var len:uint = order.length;
			for ( var i:int = 0; i < len; i++ ) {
				_order.push( order[i].id );
			}

//			Log.traceText( "_order : " + _order );

			_space = _width / ( _listMoEntities.length + 1 );

			_mapDisplayEntities = new Dictionary( true );
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
			render();
		}

		private function onDateChanged( ev:TimelineEvent ):void
		{
			render();
		}

		/**
		 * Обновляем список отображаемых сущностей
		 */
		private function render():void
		{
			var moEnt:MoEntity;
			var moEntVis:MoEntity;
			var ent:Entity;
			var title:TitleEntity;

			var listRemoved:Dictionary = new Dictionary( true );

			// Проходимся по видимым - удаляем те, которых нет в списке
			for each ( ent in _mapDisplayEntities ) {
				moEntVis = ent.moEntity;

//				Log.traceText( "( ent.y + ent.body.height ) : " + ( ent.y + ent.body.height ) );

				if ( !_mapMoEntities[ moEntVis.id ] || ( ent.body.height < _height ) && ( ( ent.y > _height ) || ( ( ent.y + ent.body.height ) <= 1 ) ) ) {
					listRemoved[ moEntVis.id ] = ent;

//					Log.traceText( "- Remove : " + moEntVis.title );
				}
			}

			// добавляем в список отображения новые объекты
			for each ( moEnt in _listMoEntities ) {
				if ( !listRemoved[ moEnt.id ] ) {
					var yy:Number = getY( moEnt );
					var hh:Number = getHeight( moEnt );
					if ( !_mapDisplayEntities[ moEnt.id ] && ( ( ( yy + hh ) > 1 ) && ( yy < _height ) ) ) {
						ent = _pool[ moEnt.id ];

						if ( ent ) {
							delete _pool[ moEnt.id ];
						} else {
							ent = new Entity( moEnt ).init();
							ent.filters = [ new GlowFilter( 0xff00ff, 1, 2, 2, 3, 3, true ) ];
						}
						_mapDisplayEntities[ moEnt.id ] = ent;
					}
				}
			}

			// Удаляем ненужные сущности
			for each ( ent in listRemoved ) {
				delete _mapDisplayEntities[ ent.moEntity.id ];
				_host.removeChild( ent );
				_pool[ ent.moEntity.id ] = ent;
			}

			// Отображаем новые и обновляем старые
			for each ( ent in _mapDisplayEntities ) {
				moEnt = ent.moEntity;


				ent.y = getY( moEnt );
				ent.height = getHeight( moEnt );

				if ( !_host.contains( ent ) ) {
					ent.x = getX( _order.indexOf( moEnt.id ) );
					moEnt.xView = ent.x; 
					_host.addChild( ent );
				}
			}
		}

		private function getX( orderIndex:uint ):Number
		{
			return _space + orderIndex * _space;
		}

		private function getY( moEntity:MoEntity ):Number
		{
			return Math.max( 0, _yCenter + MoTimeline.me.scale * ( moEntity.beginPeriod.beginJD - MoTimeline.me.baseJD ) );
		}

		private function getHeight( moEntity:MoEntity ):Number
		{
			var deltaCenterJD:Number = _yCenter / MoTimeline.me.scale;
			var beginJD:Number = Math.max( moEntity.beginPeriod.beginJD, MoTimeline.me.baseJD - deltaCenterJD );
			var endJD:Number = Math.min( MoTimeline.me.baseJD + deltaCenterJD, moEntity.endPeriod.endJD );

			return MoTimeline.me.scale * (endJD - beginJD);
		}

		public function get visibleEntities():Dictionary
		{
			return _mapDisplayEntities;
		}

		public function dispose():void
		{
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onScaleChanged );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onDateChanged );

			_host = null;
			_listMoEntities = null;
			_mapMoEntities = null;
			_mapDisplayEntities = null;
			_pool = null;
			_mapTitles = null;
		}
	}

}