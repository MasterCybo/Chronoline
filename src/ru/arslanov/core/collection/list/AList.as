/**
 * Created by aa on 12.05.2014.
 */
package ru.arslanov.core.collection.list
{
	/**
	 * Список элементов на основе вектора Vector.<Object>.
	 * Позволяет организовывать древовидные списки.
	 * Поддерживает добавление/удаление элементов, рекурсивную сортировку, получение пути элемента.
	 * @author Artem Arslanov
	 */
	public class AList extends AListItem
	{
		public static const SORT_CASEINSENSITIVE:Number = 1;
		public static const SORT_DESCENDING:Number = 2;
		public static const SORT_UNIQUESORT:Number = 4;
		public static const SORT_RETURNINDEXEDARRAY:Number = 8;
		public static const SORT_NUMERIC:Number = 16;

		private var _list:Vector.<Object> = new Vector.<Object>();
		private var _sortBehavior:*;
		private var _sortRecursive:Boolean = false;

		public function AList( sortIndex:Number = 0, data:Object = null )
		{
			super( sortIndex, data );
		}

		public function addItem( node:Object ):void
		{
			_list.push( node );
		}

		public function addItems( listNodes:Array ):void
		{
			var len:uint = listNodes.length;
			for ( var i:int = 0; i < len; i++ ) {
				addItem( listNodes[i] );
			}
		}

		/**
		 * Размещает элемент в указанном месте. Новый элемент будет помещён следующим за последним индексом пути.
		 * @param item - новый элемент.
		 * @param indexPath - целевой путь, перечень index-элементов в массиве.
		 * @example list.addItemAt( {}, [2, 1] );
		 */
		public function addItemAt( item:Object, indexPath:Array = null ):Boolean
		{
			var isAdded:Boolean = false;
			
			var idx:uint = indexPath.shift();

			if ( !indexPath.length ) {
				_list.splice( idx + 1, 0, item);
				isAdded = true;
			} else {
				var sublist:AList = _list[idx] as AList;
	
				if ( sublist ) {
					isAdded = sublist.addItemAt( item, indexPath );
				}
			}
			
			return isAdded;
		}

		/**
		 * Рекурсивное удаление элемента из списка
		 * @param item
		 * @return
		 */
		public function removeItem( item:Object ):Boolean
		{
			var isRemoved:Boolean = false;
			
			var idx:int = _list.indexOf( item );

			if ( idx != -1 ) {
				_list.splice( idx, 1 );
				isRemoved = true;
			} else {
				var childList:AList;

				for ( var i:int = 0; i < _list.length; i++ ) {
					childList = _list[i] as AList;
					if ( childList ) {
						isRemoved = childList.removeItem( item );
						
						if ( isRemoved ) break;
					}
				}
			}
			
			return isRemoved;
		}

		/**
		 * Возвращает элемент по указанному пути
		 * @param indexPath - массив индексов пути
		 * @return
		 */
		public function getItem( indexPath:Array ):Object
		{
			indexPath = indexPath.concat();
			
			var idx:int = indexPath.shift();
			var item:Object = _list[idx];

			if ( indexPath.length ) {
				var childList:AList = item as AList;
				if ( childList ) {
					item = childList.getItem( indexPath );
				}
			}
			
			return item;
		}

		/**
		 * Рекурсивный поиск пути до заданного элемента.
		 * @param item - искомый элемент.
		 * @return массив индексов пути. Если элемент не найден, тогда пустой массив.
		 */
		public function getPath( item:Object ):Array
		{
			var path:Array = [];
			
			var idx:int = _list.indexOf( item );
			
			if ( idx == -1 ) {
				var childList:AList;
				var tempPath:Array;
				
				for ( var i:int = 0; i < _list.length; i++ ) {
					childList = _list[i] as AList;
					if ( childList ) {
						tempPath = childList.getPath( item );
						if ( tempPath.length ) {
							path.push( i );
							path = path.concat( tempPath );
						}
					}
				}
			} else {
				path.push( idx );
			}
			
			return path;
		}

		/**
		 * Сортировка списка
		 * @param behavior - метод сортировки.
		 * 		Может быть 3-х типов:
		 * 			uint - побитовое сравнение SORT_...
		 * 			Function - для реализации собственной сортировки Vector.sort( sortBehavior:* ).
		 * 			String - имя свойства элемента, по которому будет осуществляться сортировка.
		 * @param recursive - рекурсивная сортировка в глубину
		 */
		public function sortBy( behavior:* = "sortIndex", recursive:Boolean = false ):void
		{
			_sortBehavior = behavior;
			
			if ( behavior is String ) {
				_list = _list.sort( compareByField );
			} else if ( (behavior is Number) || (behavior is Function) ) {
				_list = _list.sort( behavior );
			}

			_sortRecursive = recursive;
			
			if ( _sortRecursive ) {
				_list.forEach( sortRecursion );
			}

			_sortBehavior = null;
		}

		private function sortRecursion( item:Object, index:int, vector:Vector.<Object> ):void
		{
			if ( item is AList ) (item as AList).sortBy( _sortBehavior, _sortRecursive );
		}

		private function compareByField( val1:Object, val2:Object ):Number
		{
			if(val1[_sortBehavior] < val2[_sortBehavior]) return -1;
			if(val1[_sortBehavior] > val2[_sortBehavior]) return 1;
			return 0;
		}

		public function filterBy( fieldName:String, fieldValue:* = null ):Vector.<Object>
		{

		}

		public function toString():String
		{
			return "AList : " + _list;
		}

		public function toTrace():void
		{
			trace("AList :");
			trace("length : " + _list.length);

			var object:Object;
			var len:uint = _list.length;

			for ( var i:int = 0; i < len; i++ ) {
				object = _list[i];
				trace(i + " : " + object);
			}
		}

		public function dispose():void {
			_list = null;
			_sortBehavior = null;
		}
	}
}
