package collections.tree {
	import flash.utils.Dictionary;
	import ru.arslanov.core.utils.Log;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TreeList {
		
		public var onUpdate:Function;
		
		private var _root:ItemOfList = new ItemOfList( "", null, true );
		private var _removeEmpty:Boolean;
		private var _cacheRemovedItems:Array = [];
		
		public function TreeList( name:String = "rootTreeList" ) {
			_root.isRootList = true;
			_root.viewed = true;
			_root.checked = true;
			_root.keyName = name;
		}
		
		public function set rootItem( value:ItemOfList ):void {
			trace( "*execute* TreeList.rootItem" );
			value.keyName = _root.keyName;
			_root = value;
			_root.isRootList = true;
			_root.viewed = true;
			
			callUpdate();
		}
		
		public function get rootItem():ItemOfList {
			return _root;
		}
		
		public function get rootChildren():Dictionary/*ItemOfList*/ {
			return _root.children;
		}
		
		/***************************************************************************
		Добавление элемента
		***************************************************************************/
		public function addItem( item:ItemOfList ):void {
			//trace( "*execute* TreeList.addItem" );
			//trace( item.keyName + ", " + item.countChildren );
			
			addRecursive( getPath( item ), rootItem );
			
			callUpdate();
		}
		
		private function addRecursive( path:Array /*ItemOfList*/, parentItem:ItemOfList ):void {
			var pathItem:ItemOfList = path.shift();
			
			//Log.traceText( "pathItem : " + pathItem );
			
			if ( !pathItem )
				return;
			
			var item:ItemOfList = parentItem.findChild( pathItem.keyName );
			
			if ( item ) {
				if ( !path.length ) {
					var child:ItemOfList;
					var itm:ItemOfList;
					for each ( child in pathItem.children ) {
						itm = item.findChild( child.keyName );
						if ( !itm ) {
							item.pushChild( child );
						}
					}
				} else {
					addRecursive( path, item );
				}
			} else {
				parentItem.pushChild( pathItem );
			}
		}
		
		/***************************************************************************
		Удаление элемента
		***************************************************************************/
		public function removeItem( item:ItemOfList, removeEmpty:Boolean = true ):void {
			_removeEmpty = removeEmpty;
			
			removeRecursive( getPath( item ), rootItem );
			
			callUpdate();
			
			_removeEmpty = false;
		}
		
		private function removeRecursive( path:Array /*ItemOfList*/, parentItem:ItemOfList ):void {
			var pathItem:ItemOfList = path.shift();
			
			if ( !pathItem )
				return;
			
			var item:ItemOfList = parentItem.findChild( pathItem.keyName );
			
			if ( !item )
				return;
			
			if ( item.countChildren && path.length ) {
				removeRecursive( path, item );
			} else {
				parentItem.stripChild( pathItem );
				
				_cacheRemovedItems.push( pathItem );
				
				if ( _removeEmpty && !parentItem.countChildren && parentItem.parent ) {
					parentItem.parent.stripChild( parentItem );
					
					_cacheRemovedItems.push( parentItem );
				}
			}
		}
		
		private function getPath( item:ItemOfList ):Array /*ItemOfList*/ {
			var path:Array = [];
			var curParent:ItemOfList = item;
			while ( curParent ) {
				if ( !curParent.isRootList ) { // Не надо помещать корень дерева в путь
					path.unshift( curParent );
				}
				curParent = curParent.parent;
			}
			
			//trace( "path : " + path );
			
			return path;
		}
		
		public function getCacheRemovedItems():Array {
			return _cacheRemovedItems.concat();
		}
		
		/**
		 * Очистка кэша удалённых объектов
		 * Вызывать всегда, после обновления вида
		 */
		public function clearCacheRemovedItems():void {
			_cacheRemovedItems.length = 0;
		}
		
		public function getFlatArrayData( item:ItemOfList = null ):Array {
			if ( !item ) item = _root;
			
			var arr:Array = [];
			
			var childrens:Dictionary = item.children;
			var child:ItemOfList;
			for each ( child in childrens ) {
				if ( child.countChildren ) {
					arr = arr.concat( getFlatArrayData( child ) );
				} else {
					arr.push( child.dataObject );
				}
			}
			
			return arr;
		}
		
		private function callUpdate():void {
			if ( onUpdate == null )
				return;
			
			onUpdate();
		}
	}

}
