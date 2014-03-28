package display.objects {
	import flash.display.BitmapData;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BondView extends ASprite {
		
		private var _color:uint;
		private var _width:Number;
		private var _height:Number;
		private var _rank:uint;
		private var _sum:uint;
		private var _bmp:ABitmap;
		private var _bd:BitmapData;
		private var _alpha:Number;
		
		public function BondView( color:uint, alpha:Number, rank:uint, sum:uint, width:int = 100, height:uint = 20 ) {
			_color = color;
			_alpha = alpha;
			_rank = rank;
			_sum = sum;
			
			_width = Math.max( width, 2 * Settings.BOND_ROOT_WIDTH );
			_height = Math.max( height, Settings.BOND_THICKNESS );
			
			super();
		}
		
		override public function init():* {
			_bmp = new ABitmap().init();
			addChild( _bmp );
			
			draw();
			
			return super.init();
		}
		
		override public function setSize( width:Number, height:Number, rounded:Boolean = true ):void {
			if ( (width == _width) && (height == _height) ) {
				return;
			}
			
			_width = width;
			_height = Math.max( height, Settings.BOND_THICKNESS );
			
			draw();
		}
		private function draw():void {
			//if ( contains( _bmp ) ) {
				//removeChild( _bmp );
			//}
			
			// Габаритный прямоугольник
			//graphics.beginFill( 0xff00ff, 0.2 );
			//graphics.drawRect( 0, 0, _width, _height );
			//graphics.endFill();
			
			var widthRoot:Number = _width * 0.05;
			
			var rw2:Number = widthRoot / 2;
			var hw:Number = _width - rw2;
			var h2:Number = (_rank / (_sum + 1)) * ( _height - Settings.BOND_THICKNESS );
			var hh:Number = h2 + Settings.BOND_THICKNESS;
			
			graphics.clear();
			graphics.lineStyle( 1, 0xffffff, 0.2, true );
			//graphics.beginFill( _color, Settings.BOND_ALPHA );
			graphics.beginFill( _color, _alpha );
			// Левый корень связи - верхняя часть
			graphics.moveTo( 0, 0 );
			graphics.cubicCurveTo( rw2, 0,   rw2, h2,   widthRoot, h2 );
			graphics.lineTo( _width - widthRoot, h2 ); // Верхняя линия связи
			// Правый корень связи
			graphics.cubicCurveTo( hw, h2,   hw, 0,   _width, 0 );
			graphics.lineTo( _width, _height );
			graphics.cubicCurveTo( hw, _height,   hw, hh,   _width - widthRoot, hh );
			graphics.lineTo( widthRoot, hh ); // Нижняя линия связи
			// Левый корень связи - нижняя часть
			graphics.cubicCurveTo( rw2, hh,   rw2, _height,   0, _height );
			graphics.lineTo( 0, 0 );
			graphics.endFill();
			
			/*
			drawPoint(rw2, 0);
			drawPoint(rw2, h2);
			drawPoint(widthRoot, h2);
			drawPoint(_width - widthRoot, h2);
			drawPoint(_width - widthRoot, h2 + THICKNESS);
			drawPoint(widthRoot, _height - h2);
			drawPoint(rw2, _height - h2);
			drawPoint(rw2, _height);
			drawPoint(0, _height);
			drawPoint(0, 0);
			*/
			
			if ( (width < 1) || (height < 1) ) {
				return;
			}
			
			//rasterize();
			
			//addChild( _bmp );
			
			//graphics.clear();
		}
		/*
		private function drawPoint( x:Number, y:Number ):void {
			graphics.lineStyle( 1, 0x9A9A9A, 0.6 );
			graphics.lineTo( x, y );
		}
		*/
		
		private function rasterize():void {
			if ( _bd ) {
				_bd.dispose();
			}
			
			_bd = new BitmapData( width, height, true, 0x00ff0000 );
			_bd.draw( this );
			
			_bmp.bitmapData = _bd;
		}
	}

}