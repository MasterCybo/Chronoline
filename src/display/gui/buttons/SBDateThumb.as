/**
 * Created by Artem on 21.05.2014.
 */
package display.gui.buttons
{
	import display.base.ButtonApp;
	import display.skins.SBDateThumbSkin;

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

		override public function init():*
		{
//			super.skinUp = ABitmap.fromColor( 0xBFACACAC, _width, _height, true ).init();
//			super.skinOver = ABitmap.fromColor( 0XBFBBBBBB, super.skinUp.width, super.skinUp.height, true ).init();

//			super.skinUp = getBitmap( 0xACACAC ).init();
//			super.skinOver = getBitmap( 0xBBBBBB ).init();

			super.skinUp = new SBDateThumbSkin(_width, _height, 0xACACAC ).init();
			super.skinOver = new SBDateThumbSkin(_width, _height, 0xBBBBBB ).init();

			return super.init();
		}

	}

}
