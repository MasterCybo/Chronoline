package ru.arslanov.flash.gui.layout {
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * Контейнер дисплей-объектов, в котором объекты располагаются горизонтально, с регулируемым промежутком
	 * @author Artem Arslanov
	 */
	public class HBox extends VBox {
		
		private var _valign:String = "top";
		
		public function HBox( space:int = 0, direction:int = 1, verticalAlign:String = "top" ) {
			_valign = verticalAlign;
			
			super ( space, direction );
		}
		
		override public function update():void {
			var rect:Rectangle;
			var item:DisplayObject;
			var xp:Number = getFirstY();
			var len:uint = numChildren;
			var maxHeight:Number = 0;
			var i:int;
			
			for ( i = 0; i < len; i++ ) {
				item = getChildAt( i );
				rect = item.getBounds( item );
				item.x = xp - rect.x;
				xp += direction * ( item.width + space );
				
				maxHeight = Math.max( item.height, maxHeight );
			} // for
			
			for ( i = 0; i < len; i++ ) {
				item = getChildAt( i );
				
				switch ( _valign ) {
					case "bottom":
						item.y = maxHeight - item.height;
					break;
					case "middle":
						item.y = Math.round( ( maxHeight - item.height ) / 2 );
					break;
					default:
						item.y = 0;
				}
				
			} // for
			
			item = null;
			rect = null;
		}
		
		override protected function getFirstY():Number {
			return ( numChildren == 0 ) || ( direction >= 0 ) ? 0 : direction * getChildAt( 0 ).width;
		}
	}

}