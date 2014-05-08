package collections.tree {
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ItemOfList {
		
		public var displayName:String;
		public var keyName:String;
		public var parent:ItemOfList;
		public var children:Dictionary = new Dictionary( true );
		public var countChildren:uint;
		public var isRootList:Boolean;
		public var dataObject:Object;
		public var viewed:Boolean;
		
		private var _checked:Boolean;
		
		public function ItemOfList( displayName:String, keyName:String, dataObject:Object = null, isRootList:Boolean = false ) {
			this.displayName = displayName;
			this.keyName = keyName;
			this.dataObject = dataObject;
			this.isRootList = isRootList;
		}
		
		public function pushChild( item:ItemOfList ):void {
			item.parent = this;
			children[ item.keyName ] = item;
			
			item.viewed = checked;// && viewed;
			
			countChildren++;
		}
		
		public function stripChild( item:ItemOfList ):void {
			if ( !item )
				return;
			if ( !children[ item.keyName ] )
				return;
			
			item.parent = null;
			delete children[ item.keyName ];
			countChildren--;
		}
		
		public function findChild( key:String ):ItemOfList {
			var item:ItemOfList = children[ key ];
			return item ? item : null;
		}
		
		public function clone():ItemOfList {
			var item:ItemOfList = new ItemOfList( displayName, keyName, dataObject, isRootList );
			cloneParents( item );
			cloneChildren( item );
			
			item.checked = checked;
			item.viewed = viewed;
			
			return item;
		}
		
		private function cloneParents( target:ItemOfList ):void {
			var curPar:ItemOfList = (parent && !parent.isRootList) ? parent : null;
			var newPar:ItemOfList;
			
			while ( curPar ) {
				if ( !curPar.isRootList ) {
					newPar = new ItemOfList( curPar.displayName, curPar.keyName, curPar.dataObject, curPar.isRootList );
					newPar.viewed = curPar.viewed;
					newPar.checked = curPar.checked;
					newPar.pushChild( target );
				}
				
				curPar = curPar.parent;
				target = newPar;
			}
		}
		
		public function cloneChildren( target:ItemOfList ):void {
			if ( !countChildren )
				return;
			
			var newItem:ItemOfList;
			var child:ItemOfList;
			
			for each ( child in children ) {
				newItem = new ItemOfList( child.displayName, child.keyName, child.dataObject, child.isRootList );
				target.pushChild( newItem );
				
				child.cloneChildren( newItem );
			}
		}
		
		public function toString():String {
			return "[" + getQualifiedClassName( this ) + ", " + keyName + ", children: " + countChildren + "]"
		}
		
		public function get checked():Boolean {
			return _checked;
		}
		
		// Если у элемента есть дети, тогда всем детям выставляется видимость в значение value
		public function set checked( value:Boolean ):void {
			if ( value == _checked ) return;
			
			_checked = value;
			
			if (!countChildren ) return;
			
			var item:ItemOfList;
			for each ( item in children ) {
				item.viewed = _checked;
			}
		}
	}

}
