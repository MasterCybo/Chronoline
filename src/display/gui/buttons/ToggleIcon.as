package display.gui.buttons {
	import display.base.ToggleApp;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.interfaces.IKillable;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ToggleIcon extends ToggleApp {
		private var _skinUpClass:Class;
		private var _skinOverClass:Class;
		private var _skinDownClass:Class;
		private var _skinDownOverClass:Class;
		
		public function ToggleIcon(skinUpClass:Class = null, skinOverClass:Class = null, skinDownClass:Class = null, skinDownOverClass:Class = null) {
			_skinUpClass = skinUpClass;
			_skinOverClass = skinOverClass;
			_skinDownClass = skinDownClass;
			_skinDownOverClass = skinDownOverClass;
			
			super();
		
		}
		
		override protected function setupSkinsDefault():void {
			if (_skinUpClass)
				super.skinUp = ABitmap.fromClass(_skinUpClass).init();
			if (_skinOverClass)
				super.skinOver = ABitmap.fromClass(_skinOverClass).init();
			if (_skinDownClass)
				super.skinDown = ABitmap.fromClass(_skinDownClass).init();
			if (_skinDownOverClass)
				super.skinDownOver = ABitmap.fromClass(_skinDownOverClass).init();
		}
	}

}