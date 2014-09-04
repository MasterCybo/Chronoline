package ru.arslanov.flash.utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DisplayUtils {
		
		static public function toTopDepth( object:DisplayObject ):int {
			var parent:DisplayObjectContainer = object.parent;
			var depth:int = parent.getChildIndex( object );
			
			parent.setChildIndex( object, parent.numChildren - 1 );
			
			return depth;
		}
	
	}

}