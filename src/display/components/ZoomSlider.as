package display.components {
	import ru.arslanov.core.utils.Calc;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.AVScroller;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ZoomSlider extends ASprite {
		
		public function ZoomSlider() {
			super();
		}
		
		override public function init():* {
			var body:ABitmap = ABitmap.fromColor( Settings.GUI_COLOR, Settings.NAVBAR_WIDTH, 270 ).init();
			addChild( body );
			
			var track:ASprite = new ASprite().init();
			track.graphics.beginFill( 0xc8c8c8 );
			track.graphics.drawRect( 0, 0, 10, body.height - 20 );
			track.graphics.endFill();
			addChild( track );
			
			track.x = int((body.width - track.width) / 2);
			track.y = 10;
			
			return super.init();
		}
	}

}