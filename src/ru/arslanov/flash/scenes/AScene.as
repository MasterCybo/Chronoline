package ru.arslanov.flash.scenes {
	import flash.events.Event;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.interfaces.IState;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AScene extends ASprite implements IState {
		
		private var _nameScene:String = "";
		
		public function AScene( name:String ) {
			_nameScene = name;
			
			super();
		}
		
		public function get nameScene():String {
			return _nameScene;
		}
		
	}

}