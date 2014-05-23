/**
 * Created by aa on 23.05.2014.
 */
package display.skins
{
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SBDateThumbSkin extends ASprite
	{
		private var _color:uint;
		private var _width:Number;
		private var _height:Number;

		public function SBDateThumbSkin( width:Number, height:Number, color:uint = 0xff0000 )
		{
			_width = width;
			_height = height;
			_color = color;
			super();
		}

		override public function init():*
		{
			draw();
			return super.init();
		}

		override public function set height( value:Number ):void
		{
			if ( value == _height ) return;

			_height = value;

			draw();
		}

		override public function set width( value:Number ):void
		{
			if ( value == _width ) return;

			_width = value;

			draw();
		}

		private function draw():void
		{
			graphics.clear();

			graphics.lineStyle( 1, 0xBABABA );
			graphics.beginFill( _color, 0.5 );
			graphics.drawRect( 0, 0, _width - 0.5, _height );
			graphics.endFill();

			graphics.lineStyle( 1, 0xff0000, 1, true );
			graphics.moveTo( 0, _height / 2 );
			graphics.lineTo( _width - 0.5, _height / 2 );
		}
	}
}
