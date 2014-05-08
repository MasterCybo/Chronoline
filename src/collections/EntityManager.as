package collections {
	import com.adobe.utils.DictionaryUtil;

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
		static private var _length:uint;
		
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
		
		/**
		 * Минимальная дата в списке Сущностей
		 */
		static public function get minDate():Number {
			return _period.beginJD;
		}
		
		/**
		 * Максимальная дата в списке Сущностей
		 */
		static public function get maxDate():Number {
			return _period.endJD;
		}
		
		static public function get length():uint {
			return _length;
		}
		
		/**
		 * Обновление мин/макс дат
		 */
		static public function updateBounds():void {
			var item:MoEntity;
			for each ( item in _mapMoEntities ) {
				// Устанавливаем начальную дату
				if ( _period.beginJD == 0 ) {
					_period.beginJD = item.beginPeriod.beginJD;
				} else {
					if ( item.beginPeriod ) {
						_period.beginJD = Math.min( _period.beginJD, item.beginPeriod.beginJD );
					}
				}
				
				// Устанавливаем конечную дату
				if ( item.endPeriod ) {
					_period.endJD = Math.max( _period.endJD, item.endPeriod.endJD );
				}
			}
			
			Log.traceText( "EntityManager.period : " + period );
		}
		
		static public function parseJSON( json:Object ):void {
			var name:String;
			for ( name in json ) {
				addItem( MoEntity.fromJSON( json[name] ) );
			}
			
			Log.traceText( "Entities " + length + " added." );
		}
		
		/**
		 * Обнуление списка Сущностей
		 */
		static public function reset():void {
			_mapMoEntities = new Dictionary( true );
		}
	}

}