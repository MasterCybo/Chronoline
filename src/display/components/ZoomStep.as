package display.components {
	import display.gui.buttons.BtnIcon;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.layout.VBox;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ZoomStep extends ASprite {
		
		public function ZoomStep() {
			super();
		}
		
		override public function init():* {
			var vbox:VBox = new VBox().init();
			
			var btnPlus:BtnIcon = new BtnIcon( PngBtnPlus ).init();
			var btnMinus:BtnIcon = new BtnIcon( PngBtnMinus ).init();
			
			btnPlus.onRelease = onClickPlus;
			btnMinus.onRelease = onClickMinus;
			
			vbox.addChildAndUpdate( btnPlus );
			vbox.addChildAndUpdate( btnMinus );
			
			var body:ABitmap = ABitmap.fromColor( Settings.GUI_COLOR, Settings.NAVBAR_WIDTH, vbox.height + 10 ).init();
			
			vbox.x = int((body.width - vbox.width) / 2);
			vbox.y = int((body.height - vbox.height) / 2);
			
			addChild( body );
			addChild( vbox );
			
			return super.init();
		}
		
		private function onClickPlus():void {
			Log.traceText( "*execute* ZoomStep.onClickPlus" );
		}
		
		private function onClickMinus():void {
			Log.traceText( "*execute* ZoomStep.onClickMinus" );
		}
	}

}