package ru.arslanov.core.utils {
	import flash.geom.Point;
	/**
	 * Класс, связывающий координаты ячеек и пиксельные координаты сетки
	 * @author Artem Arslanov
	 */
	public class TileGrid {
		
		public var offsetX:int;
		public var offsetY:int;
		public var width:int;
		public var height:int;
		public var cols:uint;
		public var rows:uint;
		
		public var map:Array; // Пользовательский массив, может использоваться для хранения данных
		
		private var _pt:Point = new Point();
		
		public function TileGrid( width:int = 500, height:int = 500, cols:uint = 10, rows:uint = 10 ) {
			this.width = width;
			this.height = height;
			this.cols = cols;
			this.rows = rows;
		}
		
		public function getX( col:uint ):Number {
			return getXY( col, 0 ).x;
		}
		
		public function getY( row:uint ):Number {
			return getXY( 0, row ).y;
		}
		
		public function getCol( x:Number ):int {
			return getCell( x, 0 ).x;
		}
		
		public function getRow( y:Number ):int {
			return getCell( 0, y ).y;
		}
		
		public function getXY( col:uint, row:uint ):Point {
			_pt.setTo( offsetX + width * col / cols, offsetY + height * row / rows );
			return _pt;
		}
		
		public function getCell( x:uint, y:uint ):Point {
			_pt.setTo( Math.round( cols / width * x ), Math.round( rows / height * y ) );
			return _pt;
		}
		
		public function toString():String {
			return "[TileGrid]";
		}
		
		public function kill():void {
			_pt = null;
			map.length = 0;
			map = null;
		}
	}

}