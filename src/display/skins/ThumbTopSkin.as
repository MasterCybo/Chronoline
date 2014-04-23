package display.skins {

	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ThumbTopSkin extends ASprite {
		
		public function ThumbTopSkin() {
			super();
			
		}
		
		override public function init():* {
			graphics.beginFill( 0x534a30, 0.5 );
			graphics.moveTo( int( Settings.TL_BODY_WIDTH / 2 ), 0-24 );
			graphics.lineTo( Settings.TL_BODY_WIDTH, 10-24 );
			graphics.lineTo( Settings.TL_BODY_WIDTH, 24-24 );
			graphics.lineTo( 0, 24-24 );
			graphics.lineTo( 0, 10-24 );
			graphics.lineTo( int( Settings.TL_BODY_WIDTH / 2 ), 0-24 );
			
			return super.init();
		}
	}

}