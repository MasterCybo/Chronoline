package display.gui.buttons {
	import display.base.ButtonApp;

	import ru.arslanov.flash.display.ABitmap;

	/**
	 * ...
	 * @author ...
	 */
	public class BtnIcon extends ButtonApp {
		private var _skinUpClass:Class;
		private var _skinOverClass:Class;
		private var _skinDownClass:Class;
		
		public function BtnIcon( skinUpClass:Class = null, skinOverClass:Class = null, skinDownClass:Class = null ) {
			_skinUpClass = skinUpClass;
			_skinOverClass = skinOverClass;
			_skinDownClass = skinDownClass;
			
			super();
		}
		
		override protected function setupSkinsDefault():void {
			if ( _skinUpClass ) super.skinUp = ABitmap.fromClass( _skinUpClass ).init();
			if ( _skinOverClass ) super.skinOver = ABitmap.fromClass( _skinOverClass ).init();
			if ( _skinDownClass ) super.skinDown = ABitmap.fromClass( _skinDownClass ).init();
		}
	}

}