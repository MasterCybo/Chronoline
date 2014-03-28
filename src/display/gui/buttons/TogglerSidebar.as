package display.gui.buttons {
	import ru.arslanov.flash.display.ABitmap;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TogglerSidebar extends ToggleIcon {
		
		public function TogglerSidebar() {
			super();
		}
		
		override protected function setupSkinsDefault():void {
			
			var up:ABitmap = ABitmap.fromColor(Settings.SIDEBAR_COLOR, 38, 38).init();
			up.bitmapData.draw(ABitmap.fromClass(PngBtnSideOpen).init());
			
			var down:ABitmap = ABitmap.fromColor(Settings.SIDEBAR_COLOR, 38, 38).init();
			down.bitmapData.draw(ABitmap.fromClass(PngBtnSideClose).init());
			
			super.skinUp = up;
			super.skinDown = down;
		}
	}

}