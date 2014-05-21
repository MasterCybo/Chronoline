/**
 * Created by Artem on 21.05.2014.
 */
package display.skins
{
	import display.base.ButtonApp;

	import ru.arslanov.flash.display.ABitmap;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SBDateThumb extends ButtonApp
	{
		private var _width:Number;
		private var _height:Number;
		
		public function SBDateThumb( width:Number = 10, height:Number = 10 )
		{
			_width = width;
			_height = height;
			
			super();
		}
		
		override public function init():* {
			drawPic();
			return super.init();
		}

		override public function set width( value:Number ):void
		{
			if ( value == _width ) return;

			_width = value;

			drawPic();
		}

		override public function set height( value:Number ):void
		{
			if ( value == _height ) return;

			_height = value;

			drawPic();
		}

		private function drawPic():void
		{
			if ( super.skinUp ) super.skinUp.kill();
			if ( super.skinOver ) super.skinOver.kill();

			super.skinUp = ABitmap.fromColor( 0xACACAC, 15, 10 ).init();
			super.skinOver = ABitmap.fromColor( 0XBBBBBB, super.skinUp.width, super.skinUp.height ).init();
		}
	}
}
