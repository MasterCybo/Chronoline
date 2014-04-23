package display.skins {
	import display.base.ButtonApp;

	import ru.arslanov.flash.display.ABitmap;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ScrollbarThumb extends ButtonApp {
		
		public function ScrollbarThumb() {
			super();
		}
		
		override public function init():* {
			super.skinUp = ABitmap.fromColor( 0xACACAC, 15, 10 ).init();
			super.skinOver = ABitmap.fromColor( 0XBBBBBB, super.skinUp.width, super.skinUp.height ).init();
			return super.init();
		}
	}

}