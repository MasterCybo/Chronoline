package ru.arslanov.core.layout {
	import flash.geom.Rectangle;
	/**
	 * выравнивание объектов относительна заданного положения
	 * @author Artem Arslanov
	 */
	public class Align {
		
		//static public const LEFT			:String = "left";
		//static public const RIGHT			:String = "right";
		//static public const TOP				:String = "top";
		//static public const BOTTOM			:String = "bottom";
		//static public const LEFT_TOP		:String = "left_top";
		//static public const LEFT_BOTTOM		:String = "left_bottom";
		//static public const RIGHT_TOP		:String = "right_top";
		//static public const RIGHT_BOTTOM	:String = "right_bottom";
		//static public const CENTER			:String = "center";
		//static public const MIDDLE			:String = "middle";
		//
		//static public function to( position:String, rect:Rectangle, objects:Array, rounded:Boolean = true ):void {
			//
		//}
		
		static public function toCenter( rect:Rectangle, object:Object/*DisplayObject*/, rounded:Boolean = true ):void {
			if ( !rect ) throw new ArgumentError( "rect is null or empty : " + rect );
			if ( !object ) throw new ArgumentError( "object is null or empty : " + object );
			
			var bounds:Rectangle = object.getBounds( object );
			
			object.x = rounded ? Math.round( rect.x + ( ( rect.width - bounds.width ) >> 1 ) - bounds.x ) 
								: rect.x + ( ( rect.width - bounds.width ) >> 1 ) - bounds.x;
			object.y = rounded ? Math.round( rect.y + ( ( rect.height - bounds.height ) >> 1 ) - bounds.y ) 
								: rect.y + ( ( rect.height - bounds.height ) >> 1 ) - bounds.y;
			
			bounds = null;
			object = null;
		}
		
		static public function byCenterX( x:Number, objects:Array/*DisplayObject*/ ):void {
			if ( !objects || ( objects.length == 0 ) ) throw new ArgumentError( "objects is null or empty : " + objects );
			
			var bounds:Rectangle;
			
			for ( var i:int = objects.length - 1; i >= 0 ; i-- ) {
				bounds = objects[i].getBounds( objects[i] );
				objects[i].x = x - bounds.x - ( bounds.width >> 1 );
			}
			
			bounds = null;
			objects = null;
		}
		
		static public function byCenterY( y:Number, objects:Array/*DisplayObject*/ ):void {
			if ( !objects || ( objects.length == 0 ) ) throw new ArgumentError( "objects is null or empty : " + objects );
			
			var bounds:Rectangle;
			
			for ( var i:int = objects.length - 1; i >= 0 ; i-- ) {
				bounds = objects[i].getBounds( objects[i] );
				objects[i].y = y - bounds.y - ( bounds.height >> 1 );
			}
			
			bounds = null;
			objects = null;
		}
		
		/**
		 * Выравнивание по левому краю
		 * @param	x
		 * @param	objects - массив DisplayObject
		 */
		static public function toL( rect:Rectangle, objects:Array/*DisplayObject*/ ):void {
			if ( !objects || ( objects.length == 0 ) ) throw new ArgumentError( "objects is null or empty : " + objects );
			
			var bounds:Rectangle;
			
			for ( var i:int = objects.length - 1; i >= 0 ; i-- ) {
				bounds = objects[i].getBounds( objects[i] );
				objects[i].x = rect.left - bounds.x;
			}
			
			bounds = null;
			objects = null;
		}
		
		/**
		 * Выравнивание по правому краю
		 * @param	x
		 * @param	objects - массив DisplayObject
		 */
		static public function toR( rect:Rectangle, objects:Array/*DisplayObject*/ ):void {
			if ( !objects || ( objects.length == 0 ) ) throw new ArgumentError( "objects is null or empty : " + objects );
			
			var bounds:Rectangle;
			
			for ( var i:int = objects.length - 1; i >= 0 ; i-- ) {
				bounds = objects[i].getBounds( objects[i] );
				objects[i].x = rect.right - bounds.x - bounds.width;
			}
			
			bounds = null;
			objects = null;
		}
		
		/**
		 * Выравнивание по верхнему краю
		 * @param	y
		 * @param	objects - массив DisplayObject
		 */
		static public function toT( rect:Rectangle, objects:Array/*DisplayObject*/ ):void {
			if ( !objects || ( objects.length == 0 ) ) throw new ArgumentError( "objects is null or empty : " + objects );
			
			var bounds:Rectangle;
			
			for ( var i:int = objects.length - 1; i >= 0 ; i-- ) {
				bounds = objects[i].getBounds( objects[i] );
				objects[i].y = rect.top - bounds.y;
			}
			
			bounds = null;
			objects = null;
		}
		
		/**
		 * Выравнивание по нижнему краю
		 * @param	y
		 * @param	objects - массив DisplayObject
		 */
		static public function toB( rect:Rectangle, objects:Array/*DisplayObject*/ ):void {
			if ( !objects || ( objects.length == 0 ) ) throw new ArgumentError( "objects is null or empty : " + objects );
			
			var bounds:Rectangle;
			
			for ( var i:int = objects.length - 1; i >= 0 ; i-- ) {
				bounds = objects[i].getBounds( objects[i] );
				objects[i].y = rect.bottom - bounds.y - bounds.width;
			}
			
			bounds = null;
			objects = null;
		}
		
		static public function toLT( rect:Rectangle, displayObject:Object ):void {
			if ( !displayObject ) throw new ArgumentError( "displayObject is null : " + displayObject );
			
			var bounds:Rectangle = displayObject.getBounds( displayObject );
			
			displayObject.x = rect.left;
			displayObject.y = rect.top;
			
			bounds = null;
		}
		
		static public function toLB( rect:Rectangle, displayObject:Object ):void {
			if ( !displayObject ) throw new ArgumentError( "displayObject is null : " + displayObject );
			
			var bounds:Rectangle = displayObject.getBounds( displayObject );
			
			displayObject.x = rect.left;
			displayObject.y = rect.bottom - bounds.y - bounds.width;
			
			bounds = null;
		}
		
		static public function toRT( rect:Rectangle, displayObject:Object ):void {
			if ( !displayObject ) throw new ArgumentError( "displayObject is null : " + displayObject );
			
			var bounds:Rectangle = displayObject.getBounds( displayObject );
			
			displayObject.x = rect.right + bounds.x - bounds.width;
			displayObject.y = rect.top + bounds.y;
			
			bounds = null;
		}
		
		static public function toRB( rect:Rectangle, displayObject:Object ):void {
			if ( !displayObject ) throw new ArgumentError( "displayObject is null : " + displayObject );
			
			var bounds:Rectangle = displayObject.getBounds( displayObject );
			
			displayObject.x = rect.right + bounds.x - bounds.width;
			displayObject.y = rect.bottom - bounds.y - bounds.width;
			
			bounds = null;
		}
	}

}