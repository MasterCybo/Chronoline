package ru.arslanov.core.utils {
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Place {
		
		public var x:int;
		public var y:int;
		
		public var cols:int;
		public var rows:int;
		
		private var _idx:int;
		
		private var _objects:Array = [];
		
		public function Place( cols:int = -1, rows:int = 1 ) {
			this.cols = cols;
			this.rows = rows;
		}
		
		public function right( obj:* ):uint {
			_idx = _objects.push( obj ) - 1;
			
			update();
			
			return _idx;
		}
		
		public function left( obj:* ):uint {
			_idx = Math.max( 0, _idx - 1 );
			_objects.splice( idx, 0, obj );
			
			return _idx;
		}
		
		public function top( obj:* ):uint {
			
		}
		
		public function bottom( obj:* ):uint {
			
		}
		
		public function push( col:uint, row:uint, obj:* ):uint {
			
		}
		
		public function pushIdx( idx:uint, obj:* ):uint {
			
		}
		
		public function remove( col:uint, row:uint ):void {
			
		}
		
		public function removeIdx( idx:uint ):void {
			
		}
		
		public function getObject( col:uint, row:uint ):* {
			
		}
		
		public function getObjectIdx( idx:uint ):* {
			
		}
		
		private function update():void {
			
		}
		
		public function kill():void {
			_objects = null;
		}
	}

}