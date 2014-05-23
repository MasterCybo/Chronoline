/**
 * Created by Artem on 21.05.2014.
 */
package display.skins
{
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ScrollbarBody extends ASprite
	{
		private var _pic:ABitmap;
		private var _width:Number;
		private var _height:Number;
		
		public function ScrollbarBody( width:Number = 10, height:Number = 10 )
		{
			_width = width;
			_height = height;
			
			super();
		}

		override public function init():*
		{
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
			if ( _pic ) _pic.kill();

			_pic = ABitmap.fromColor( 0xDDDDDD, _width, _height ).init();
			addChild( _pic );
		}
	}
}
