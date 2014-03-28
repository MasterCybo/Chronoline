package collections {
	import com.adobe.utils.DictionaryUtil;
	import data.MoDate;
	import data.MoEntity;
	import data.MoPeriod;
	import flash.utils.Dictionary;
	import ru.arslanov.core.utils.Log;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntityManager {
		
		static private var _mapMoEntities:Dictionary/*MoEntity*/ = new Dictionary( true ); // MoEntity.id = MoEntity;
		
		static private var _period:MoPeriod = new MoPeriod();
		
		public function EntityManager() {
			
		}
		
		/**
		 * Добавление новой Сущности
		 * @param	entity
		 */
		static public function addItem( entity:MoEntity ):void {
			if ( getItem( entity.id ) ) {
				Log.traceWarn( "EntityManager.addItem( " + entity.id + " ) already exists!" );
				return;
			}
			
			_mapMoEntities[entity.id] = entity;
			
			updateBounds();
		}
		
		/**
		 * Получение Сущности по id
		 * @param	id
		 * @return
		 */
		static public function getItem( id:String ):MoEntity {
			return _mapMoEntities[id];
		}
		
		/**
		 * Удаление Сущности по id
		 * @param	id
		 */
		static public function removeItem( id:String ):void {
			delete _mapMoEntities[id];
		}
		
		/**
		 * Проверка наличия Сущности
		 * @param	id
		 * @return
		 */
		static public function hasItem( id:String ):Boolean {
			return _mapMoEntities[id] != undefined;
		}
		
		/**
		 * Получения списка Сущностей в виде массива
		 * @return
		 */
		static public function getArrayEntities():Array/*MoEntity*/ {
			//for (var name:String in _entities) {
				//Log.traceText( name + " : " + _entities[name] );
			//}
			
			var arr:Array/*MoEntity*/ = DictionaryUtil.getValues( _mapMoEntities );
			arr.sortOn( ["id"], [Array.NUMERIC] );
			
			return arr;
		}
		
		static public function get mapMoEntities():Dictionary {
			return _mapMoEntities;
		}
		
		static public function getKeys():Array {
			return DictionaryUtil.getKeys( _mapMoEntities );
		}
		
		/**
		 * 
		 */
		static public function get period():MoPeriod {
			return _period;
		}
		
		/**
		 * Минимальная дата в списке Сущностей
		 */
		static public function get minDate():MoDate {
			return _period.dateBegin;
		}
		
		/**
		 * Максимальная дата в списке Сущностей
		 */
		static public function get maxDate():MoDate {
			return _period.dateEnd;
		}
		
		/**
		 * Обновление мин/макс дат
		 */
		static public function updateBounds():void {
			var item:MoEntity;
			for each ( item in _mapMoEntities ) {
				// Устанавливаем начальную дату
				if ( _period.dateBegin.jd == 0 ) {
					_period.dateBegin.jd = item.beginPeriod.dateBegin.jd;
				} else {
					if ( item.beginPeriod ) {
						_period.dateBegin.jd = Math.min( _period.dateBegin.jd, item.beginPeriod.dateBegin.jd );
					}
				}
				
				// Устанавливаем конечную дату
				if ( item.endPeriod ) {
					_period.dateEnd.jd = Math.max( _period.dateEnd.jd, item.endPeriod.dateEnd.jd );
				}
			}
			
			Log.traceText( "EntityManager.period : " + period );
		}
		
		static public function parseJSON( json:Object ):void {
			var num:uint;
			for ( var name:String in json ) {
				num++;
				addItem( MoEntity.fromJSON( json[name] ) );
			}
			
			Log.traceText( "Entities " + num + " added." );
		}
		
		/**
		 * Обнуление списка Сущностей
		 */
		static public function reset():void {
			_mapMoEntities = new Dictionary( true );
		}
	}

}