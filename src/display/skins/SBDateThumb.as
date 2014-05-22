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
			super.skinUp = ABitmap.fromColor( 0xACACAC, _width, _height ).init();
			super.skinOver = ABitmap.fromColor( 0XBBBBBB, super.skinUp.width, super.skinUp.height ).init();
			
			return super.init();
		}
	}
	
}
