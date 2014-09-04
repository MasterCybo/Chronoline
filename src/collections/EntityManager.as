package collections {

	import com.adobe.utils.DictionaryUtil;

	import data.MoEntity;
	import data.MoPeriod;

	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.JDUtils;

	import ru.arslanov.core.utils.Log;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntityManager {
		
		static private var _mapMoEntities:Dictionary/*MoEntity*/ = new Dictionary( true ); // MoEntity.id = MoEntity;
		static private var _period:MoPeriod = new MoPeriod();
		static private var _length:uint;
		
		public function EntityManager() {
			
		}
		
		/**
		 * Добавление новой Сущности
		 * @param	entity
		 */
		static public function addItem( entity:MoEntity ):void {
			if ( hasItem( entity.id ) ) {
				Log.traceWarn( "EntityManager.addItem( " + entity.id + " ) already exists!" );
				return;
			}
			
			_mapMoEntities[entity.id] = entity;
			_length++;
			
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
			if (!hasItem(id)) {
				Log.traceWarn( "EntityManager.removeItem( " + id + " ) not exists!" );
				return;
			}
			delete _mapMoEntities[id];
			_length--;
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
		 * Получение списка Сущностей в виде массива, отсортированных по ID
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
		
		/**
		* Ссылка на карту сущностей
		* MoEntity.id = MoEntity;
		*/
		static public function get mapMoEntities():Dictionary/*MoEntity*/ {
			return _mapMoEntities;
		}
		
		/**
		 * 
		 */
		static public function get period():MoPeriod {
			return _period;
		}

		static public function get length():uint {
			return _length;
		}
		
		/**
		 * Обновление мин/макс дат
		 */
		static public function updateBounds():void {
			_period.beginJD = JDUtils.MIN_YEAR;
			_period.endJD = JDUtils.MIN_YEAR;

			var moEnt:MoEntity;
			for each ( moEnt in _mapMoEntities ) {
				// Устанавливаем начальную дату
				if ( _period.beginJD == JDUtils.MIN_YEAR ) {
					_period.beginJD = moEnt.beginPeriod.beginJD;
				} else {
					if ( moEnt.beginPeriod ) {
						_period.beginJD = Math.min( _period.beginJD, moEnt.beginPeriod.beginJD );
					}
				}
				
				// Устанавливаем конечную дату
				if ( moEnt.endPeriod ) {
					_period.endJD = Math.max( _period.endJD, moEnt.endPeriod.endJD );
				}
			}
		}

		/**
		 * Обнуление списка Сущностей
		 */
		static public function removeAllEntities():void {
			_mapMoEntities = new Dictionary( true );
			_period.beginJD = JDUtils.MIN_YEAR;
			_period.endJD = JDUtils.MIN_YEAR;
			_length = 0;
		}

		/**
		 * Удаляет сущности, которых нет в векторе и возвращает список ID новых сущностей, которых нет в словаре (данные не загружены)
		 * @param listIDs
		 * @return
		 */
		public static function refineMissingEntities( listIDs:Vector.<String> ):Vector.<String>
		{
			var listDiff:Vector.<String> = listIDs.concat();

			// Удаляем из словаря которых нет в списке
			var moEnt:MoEntity;
			for each ( moEnt in _mapMoEntities ) {
				if ( listDiff.indexOf(moEnt.id) == -1 ) delete _mapMoEntities[moEnt.id];
			}

			// Удаляем из списка, которые есть в словаре
			var len:uint = listDiff.length - 1;
			for (var i:int = len; i >=0; i--) {
				if ( hasItem(listDiff[i]) ) listDiff.splice(i, 1);
			}

			return listDiff;
		}
	}

}