package display.skins {
	
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ThumbSkin extends ASprite {
		
		public function ThumbSkin() {
			super();
		}
		
		override public function init():* {
			drawBody( 100 );
			
			return super.init();
		}
		
		override public function setSize( width:Number, height:Number, rounded:Boolean = true ):void {
			drawBody( height );
		}
		
		private function drawBody( height:uint ):void {
			graphics.clear();
			graphics.beginFill( Settings.THUMB_BODY_CLR );
			graphics.drawRect( 0, 0, Settings.TL_BODY_WIDTH, height );
			graphics.endFill();
		}
	}

}