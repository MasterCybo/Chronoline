package display.components {
	import ru.arslanov.core.utils.Calc;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class FactIconEmpty extends ASprite {
		
		private var _rank:uint; // Расштаб иконки 0-100%
		
		public function FactIconEmpty( rank:uint = 0 ) {
			_rank = Calc.constrain( Settings.MIN_RANK, rank, Settings.MAX_RANK );
			
			super();
		}
		
		override public function init():* {
			scaleX = scaleY = _rank * 0.01;
			
			var bmp:ABitmap = ABitmap.fromColor( 0x80ff0000, Settings.ICON_SIZE, Settings.ICON_SIZE, true ).init();
			addChild( bmp );
			
			return super.init();
		}
	}

}
