package display.gui {
	import display.components.ZoomSlider;
	import display.components.ZoomStep;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.layout.VBox;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class NavigationBar extends VBox {
		
		public function NavigationBar() {
			super();
		}
		
		override public function init():* {
			var zoSlider:ZoomSlider = new ZoomSlider().init();
			var zoStep:ZoomStep = new ZoomStep().init();
			
			addChildAndUpdate( zoSlider );
			addChildAndUpdate( zoStep );
			
			return super.init();
		}
	}

}