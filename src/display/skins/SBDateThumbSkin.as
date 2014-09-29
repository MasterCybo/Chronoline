/**
 * Created by aa on 23.05.2014.
 */
package display.skins
{
	import flash.geom.Point;

	import ru.arslanov.flash.display.AShape;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.display.Bmp9Scale;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SBDateThumbSkin extends ASprite
	{
		private var _width:Number;
		private var _height:Number;
		private var _pic:Bmp9Scale;
		private var _line:AShape;

		public function SBDateThumbSkin( width:Number, height:Number )
		{
			_width = width;
			_height = height;
			super();
		}

		override public function init():*
		{
			super.init();

			_pic = Bmp9Scale.createFromClass( PngBtnSlider, new Point(5,5), new Point(5,5), false ).init();
			addChild(_pic);

			_line = new AShape().init();
			_line.graphics.lineStyle( 1, 0xff0000, 1, true );
			_line.graphics.moveTo( 0, 0 );
			_line.graphics.lineTo( _width - 0.5, 0 );
			addChild(_line);

			draw();

			return this;
		}

		override public function setSize( width:Number, height:Number, rounded:Boolean = true ):void
		{
			super.setSize( width, height, rounded );

			draw();
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

			_line.graphics.clear();
			_line.graphics.lineStyle( 1, 0xff0000, 1, true );
			_line.graphics.moveTo( 0, 0 );
			_line.graphics.lineTo( _width - 0.5, 0 );

			_pic.setSize( _width, _height );
			_line.y = int( _height / 2 );
		}
	}
}
