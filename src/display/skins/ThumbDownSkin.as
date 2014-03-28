package display.skins {
	
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ThumbDownSkin extends ASprite {
		
		public function ThumbDownSkin() {
			super();
		}
		
		override public function init() : * {
			graphics.beginFill( 0x534a30, 0.5 );
			graphics.moveTo( 0, 0 ); // 
			graphics.lineTo( Settings.TL_BODY_WIDTH, 0 );
			graphics.lineTo( Settings.TL_BODY_WIDTH, 10 );
			graphics.lineTo( int( Settings.TL_BODY_WIDTH / 2 ), 24 );
			graphics.lineTo( 0, 10 );
			graphics.lineTo( 0, 0 );
			graphics.endFill();
			
			return super.init();
		}
	}

}