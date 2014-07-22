package display.objects {

	import flash.display.BitmapData;
	import flash.filters.GlowFilter;

	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * Сущность хроноленты
	 * @author Artem Arslanov
	 */
	public class EntityView extends ASprite {
		
		private var _height:Number;
		private var _bmp:ABitmap;
		private var _bmpData:BitmapData;
		private var _color:uint;
		
		public function EntityView( height:Number = 100, color:uint = 0xBCD948 ) {
			_height = Math.max( 1, height );
			
			_color = color;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			mouseEnabled = true;
			doubleClickEnabled = true;
			buttonMode = true;
			
			_bmp = new ABitmap().init();
			
			draw();

			filters = [ new GlowFilter( 0xff00ff, 1, 2, 2, 3, 3, true ) ];
			
			return this;
		}
		
		override public function set height( value:Number ):void {
			if ( value == _height ) return;
			
			_height = Math.max( 1, value );
			
			draw();
		}
		
		override public function get height():Number {
			return _height;
		}
		
		/***************************************************************************
		Рисуем сущность
		***************************************************************************/
		private function draw():void {
			//*/
			// Рисуем тело
			//graphics.beginFill( Settings.ENT_CLR_BODY );
			graphics.beginFill( _color );
			graphics.drawRect( 0, 0, Settings.ENT_WIDTH, uint( _height ) );
			graphics.endFill();
			
			/*/
			// Со стрелками в начале и конце
			graphics.beginFill( Settings.ENT_CLR_BODY );
			graphics.moveTo( 0, Settings.ENT_ARROW_HEIGHT );
			graphics.lineTo( Settings.ENT_WIDTH / 2, 0 );
			graphics.lineTo( Settings.ENT_WIDTH, Settings.ENT_ARROW_HEIGHT );
			graphics.lineTo( Settings.ENT_WIDTH, _height - Settings.ENT_ARROW_HEIGHT );
			graphics.lineTo( Settings.ENT_WIDTH / 2, _height );
			graphics.lineTo( 0, _height - Settings.ENT_ARROW_HEIGHT );
			graphics.lineTo( 0, Settings.ENT_ARROW_HEIGHT );
			graphics.endFill();
			//*/
			
			rasterize();
			
			graphics.clear();
		}
		
		private function rasterize():void {
			if ( contains( _bmp ) ) removeChild( _bmp );
			
			_bmpData = new BitmapData( width, height, true, 0xff0000 );
			_bmpData.draw( this );
			
			_bmp.bitmapData = _bmpData;
			
			addChild( _bmp );
		}
	}

}
