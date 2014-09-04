package ru.arslanov.flash.gui.windows {
	import ru.arslanov.flash.interfaces.IKillable;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ConfigWindowBase {
		
		public var title:String = "";
		
		public var width:uint = 100;
		public var height:uint = 100;
		public var position:Object = "center";
		
		public var skinBody:IKillable;
		
		public function ConfigWindowBase() {
			
		}
		
		public function init():* {
			// override me
			return this;
		}
	}

}