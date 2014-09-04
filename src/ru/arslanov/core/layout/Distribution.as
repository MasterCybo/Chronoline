package ru.arslanov.core.layout {
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Distribution {
		
		static public function vertical( displayObjects:Array/*DisplayObject*/, space:Number = 0, round:Boolean = true ):void {
			if ( !displayObjects ) throw new Error ("Distribution.vertical :: displayObjects is null");
			if ( displayObjects.length == 0 ) throw new Error ("Distribution.vertical :: displayObjects is empty");
			
			var len:Number = displayObjects.length;
			var newY:Number = round ? Math.round( displayObjects[0].y ) : displayObjects[0].y;
			
			for (var i:int = 0; i < len; i++) {
				displayObjects[i].y = newY;
				newY += round ? Math.round( displayObjects[i].height + space ) : displayObjects[i].height + space;
			}
			
			displayObjects = null;
		}
		
		static public function horizontal( displayObjects:Array/*DisplayObject*/, space:Number = 0, round:Boolean = true ):void {
			if ( !displayObjects ) throw new Error ("Distribution.horizontal :: displayObjects is null");
			if ( displayObjects.length == 0 ) throw new Error ("Distribution.horizontal :: displayObjects is empty");
			
			var len:Number = displayObjects.length;
			var newX:Number = round ? Math.round( displayObjects[0].x ) : displayObjects[0].x;
			
			for (var i:int = 0; i < len; i++) {
				displayObjects[i].x = newX;
				newX += round ? Math.round( displayObjects[i].width + space ) : displayObjects[i].width + space;
			}
			
			displayObjects = null;
		}
		
		static public function alignCenterX( x:Object = null, displayObjects:Array/*DisplayObject*/, round:Boolean = true ):void {
			var len:Number = displayObjects.length;
			var i:int;
			
			var x0:Number = 0;
			
			if (!x) {
				var maxWidth:Number = 0;
				for (i = 0; i < len; i++) {
					if (maxWidth < displayObjects[i].width) {
						maxWidth = displayObjects[i].width;
						x0 = displayObjects[i].x;
					}
				}
			} else {
				x0 = Number( x );
			}
			
			for (i = 0; i < len; i++) {
				displayObjects[i].x = round ? Math.round( x0 - (displayObjects[i].width >> 1 )) : x0 - (displayObjects[i].width >> 1);
			}
			
			displayObjects = null;
		}
		
		static public function alignCenterY( y:Object = null, displayObjects:Array/*DisplayObject*/, round:Boolean = true ):void {
			var len:Number = displayObjects.length;
			var i:int;
			
			var y0:Number = 0;
			
			if (!y) {
				var maxHeight:Number = 0;
				for (i = 0; i < len; i++) {
					if (maxHeight < displayObjects[i].height) {
						maxHeight = displayObjects[i].height;
						y0 = displayObjects[i].y;
					}
				}
			} else {
				y0 = Number( y );
			}
			
			for (i = 0; i < len; i++) {
				displayObjects[i].y = round ? Math.round( y0 - (displayObjects[i].height >> 1)) : y0 - (displayObjects[i].height >> 1);
			}
			
			displayObjects = null;
		}
		
		static public function center( width:Number, height:Number, object:*, round:Boolean = true ):void {
			object.x = round ? Math.round( (width - object.width) >> 1 ) : (width - object.width) >> 1;
			object.y = round ? Math.round( (height - object.height) >> 1 ) : (height - object.height) >> 1;
		}
		
		static public function grid( cols:uint, rows:uint, displayObjects:Array/*DisplayObject*/, round:Boolean = true ):void {
			if ( !displayObjects ) throw new Error ("Distribution.grid :: displayObjects is null");
			if ( displayObjects.length == 0 ) throw new Error ("Distribution.grid :: displayObjects is empty");
			
			
		}
	}

}