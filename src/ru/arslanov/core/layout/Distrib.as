package ru.arslanov.core.layout {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Distribution - распределение
	 * @author Artem Arslanov
	 */
	public class Distrib {
		
		static public const ROUNDED:String = "rounded";
		static public const SPACE:String = "space";
		static public const X:String = "x";
		static public const Y:String = "y";
		static public const WIDTH:String = "width";
		static public const HEIGHT:String = "height";
		static public const COLS:String = "cols";
		static public const ROWS:String = "rows";
		static public const CENTERING:String = "centering";
		
		static private var _rounded:Boolean = true;
		static private var _centering:Boolean = false;
		static private var _space:Number = 0;
		static private var _x0:Number = 0;
		static private var _y0:Number = 0;
		static private var _width:Number = 0;
		static private var _height:Number = 0;
		static private var _cols:uint;
		static private var _rows:uint;
		
		
		static private function setParams( params:Object ):void {
			//trace( "CALL >> Distrib.setParams" );
			_rounded 		= params && params[ROUNDED] ? params[ROUNDED] == "true" : true;
			_centering 		= params && params[CENTERING] ? params[CENTERING] 		: false;
			_space 			= params && params[SPACE] 	? Number( params[SPACE] ) 	: 0;
			_x0 			= params && params[X] 		? Number( params[X] ) 		: 0;
			_y0 			= params && params[Y] 		? Number( params[Y] ) 		: 0;
			_width 			= params && params[WIDTH] 	? Number( params[WIDTH] ) 	: 0;
			_height 		= params && params[HEIGHT] 	? Number( params[HEIGHT] ) 	: 0;
			_cols 			= params && params[COLS] 	? uint( params[COLS] ) 		: 0;
			_rows 			= params && params[ROWS] 	? uint( params[ROWS] ) 		: 0;
			
			//trace( "_rounded : " + _rounded );
			//trace( "_space : " + _space );
			//trace( "_x0 : " + _x0 );
			//trace( "_y0 : " + _y0 );
			//trace( "_width : " + _width );
			//trace( "_height : " + _height );
			//trace( "_cols : " + _cols );
			//trace( "_rows : " + _rows );
			//trace( "_centering : " + _centering );
		}
		
		
		static public function vertical( params:Object, displayObjects:Array/*DisplayObject*/ ):void {
			if ( !displayObjects ) throw new Error ("Distrib.vertical :: displayObjects is null");
			if ( displayObjects.length == 0 ) throw new Error ("Distrib.vertical :: displayObjects is empty");
			
			setParams( params );
			
			var i:int;
			var obj:Object;
			var bounds:Rectangle;
			var len:Number = displayObjects.length;
			var yp:Number = _rounded ? Math.round( _y0 ) : _y0;
			
			for (i = 0; i < len; i++) {
				obj = displayObjects[i];
				bounds = obj.getBounds( obj );
				
				obj.x = _centering ? _x0 - ( bounds.width >> 1 ) : _x0;
				obj.y = yp;
				yp += _rounded ? Math.round( bounds.height + _space ) : bounds.height + _space;
			}
			
			displayObjects = null;
		}
		
		//static public function horizontal( params:Object, displayObjects:Array/*DisplayObject*/ ):void {
			//if ( !displayObjects ) throw new Error ("Distrib.horizontal :: displayObjects is null");
			//if ( displayObjects.length == 0 ) throw new Error ("Distrib.horizontal :: displayObjects is empty");
			//
			//var len:Number = displayObjects.length;
			//var newX:Number = _rounded ? Math.round( displayObjects[0].x ) : displayObjects[0].x;
			//
			//for (var i:int = 0; i < len; i++) {
				//displayObjects[i].x = newX;
				//newX += _rounded ? Math.round( displayObjects[i].width + _space ) : displayObjects[i].width + _space;
			//}
			//
			//displayObjects = null;
		//}
		
		//static public function alignCenterX( params:Object, displayObjects:Array/*DisplayObject*/ ):void {
			//var len:Number = displayObjects.length;
			//var i:int;
			//
			//var x0:Number = 0;
			//
			//if (!x) {
				//var maxWidth:Number = 0;
				//for (i = 0; i < len; i++) {
					//if (maxWidth < displayObjects[i].width) {
						//maxWidth = displayObjects[i].width;
						//x0 = displayObjects[i].x;
					//}
				//}
			//} else {
				//x0 = Number( x );
			//}
			//
			//for (i = 0; i < len; i++) {
				//displayObjects[i].x = _rounded ? Math.round( x0 - (displayObjects[i].width >> 1 )) : x0 - (displayObjects[i].width >> 1);
			//}
			//
			//displayObjects = null;
		//}
		//
		//static public function alignCenterY( params:Object, displayObjects:Array/*DisplayObject*/ ):void {
			//var len:Number = displayObjects.length;
			//var i:int;
			//
			//var y0:Number = 0;
			//
			//if (!y) {
				//var maxHeight:Number = 0;
				//for (i = 0; i < len; i++) {
					//if (maxHeight < displayObjects[i].height) {
						//maxHeight = displayObjects[i].height;
						//y0 = displayObjects[i].y;
					//}
				//}
			//} else {
				//y0 = Number( y );
			//}
			//
			//for (i = 0; i < len; i++) {
				//displayObjects[i].y = _rounded ? Math.round( y0 - (displayObjects[i].height >> 1)) : y0 - (displayObjects[i].height >> 1);
			//}
			//
			//displayObjects = null;
		//}
		//
		//static public function center( params:Object, object:* ):void {
			//object.x = _rounded ? Math.round( (width - object.width) >> 1 ) : (width - object.width) >> 1;
			//object.y = _rounded ? Math.round( (height - object.height) >> 1 ) : (height - object.height) >> 1;
		//}
		
		/**
		 * Распределение объектов плиткой
		 * @param	x - начальная точка
		 * @param	y - 
		 * @param	cols - количество столбцов. При задании 0 - значение не учитывается
		 * @param	rows - количество строк При задании 0 - значение не учитывается
		 * @param	space - расстояние между плитками
		 * @param	rounded - округление координат
		 * @param	displayObjects - список объектов
		 */
		static public function tile( params:Object, displayObjects:Array/*DisplayObject*/ ):void {
			if ( !displayObjects ) throw new ArgumentError ("Distrib.tile :: displayObjects is null");
			if ( displayObjects.length == 0 ) throw new ArgumentError ("Distrib.tile :: displayObjects is empty");
			
			setParams( params );
			
			
			var xp:Number = _x0;
			var yp:Number = _y0;
			var cols:uint;
			var rows:uint;
			var bounds:Rectangle;
			var obj:Object;
			
			
			var len:uint = displayObjects.length;
			
			for (var i:int = 0; i < len; i++) {
				obj = displayObjects[i];
				
				bounds = obj.getBounds( obj );
				
				obj.x = _rounded ? Math.round( xp - bounds.x ) : xp - bounds.x;
				obj.y = _rounded ? Math.round( yp - bounds.y ) : yp - bounds.y;
				
				if ( _cols > 0 ) {
					cols++;
					
					if ( cols >= _cols ) {
						cols = 0;
						xp = _x0;
						yp += bounds.height + _space;
					} else {
						xp += bounds.width + _space;
					}
				} else if ( _rows > 0 ) {
					rows++;
					
					if ( rows >= _rows ) {
						rows = 0;
						yp = _y0;
						xp += bounds.width + _space;
					} else {
						yp += bounds.height + _space;
					}
				}
				
			}
			
			bounds = null;
			obj = null;
			displayObjects = null;
		}
		
		// TODO: Реализовать размещение объектов по сетке
		static public function grid( params:Object, displayObjects:Array/*DisplayObject*/ ):void {
			if ( !displayObjects ) throw new ArgumentError ("Distrib.grid :: displayObjects is null");
			if ( displayObjects.length == 0 ) throw new ArgumentError ("Distrib.grid :: displayObjects is empty");
			
			setParams( params );
			
			var xp:Number = _x0;
			var yp:Number = _y0;
			var cols:uint;
			var rows:uint;
			var bounds:Rectangle;
			var obj:DisplayObject;
			
			
			var len:uint = displayObjects.length;
			
			for (var i:int = 0; i < len; i++) {
				obj = displayObjects[i];
				
				bounds = obj.getBounds( obj );
				
				obj.x = _rounded ? Math.round( xp - bounds.x ) : xp - bounds.x;
				obj.y = _rounded ? Math.round( yp - bounds.y ) : yp - bounds.y;
			}
			
			bounds = null;
			obj = null;
			displayObjects = null;
		}
	}

}