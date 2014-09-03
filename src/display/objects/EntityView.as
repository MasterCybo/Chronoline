package display.objects {

	import data.MoEntity;
	import data.MoRankEntity;
	import data.MoTimeline;

	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import ru.arslanov.core.utils.JDUtils;

	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * Сущность хроноленты
	 * @author Artem Arslanov
	 */
	public class EntityView extends ASprite {
		
		private var _height:Number;
		private var _bmp:ABitmap;
		private var _canvas:ASprite;
		private var _color:uint;
		private var _offsetY:Number = 0;
		private var _moEntity:MoEntity;
		
		public function EntityView( moEntity:MoEntity, height:Number = 100, color:uint = 0xBCD948 ) {
			_height = Math.max( 1, height );
			_color = color;
			_moEntity = moEntity;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			mouseEnabled = true;
			doubleClickEnabled = true;
			buttonMode = true;

			_canvas = new ASprite().init();
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

		public function setHeight( heightValue:Number, offsetY:Number = 0 ):void
		{
			_offsetY = Math.min(offsetY, 0);

			this.height = heightValue;
		}
		
		/***************************************************************************
		Рисуем сущность
		***************************************************************************/
		private function draw():void {
			_canvas.graphics.beginFill( _color );
			_canvas.graphics.moveTo(0, _offsetY);

//			Log.traceText( "_height : " + _height );
//			Log.traceText( "_offsetY : " + _offsetY );

			var ranks:Vector.<MoRankEntity> = _moEntity.ranks;
			var hh:Number = _moEntity.duration * MoTimeline.me.scale;

			if ( ranks.length > 0 ) {
				var minWW:Number = Settings.ENT_WIDTH_MIN;
				var cx:Number = minWW;
				var y0:Number = 0;
				var y1:Number = 0;
				var dy:Number = 0;

				_canvas.graphics.lineTo( minWW, _offsetY );

				for ( var i:uint = 0; i<ranks.length; i++ ) {
					var moRank:MoRankEntity = ranks[i];
					var rankWidth:Number = minWW + moRank.rank * minWW;

					y1 = moRank.fromPercent * hh;
					dy = ( y0 + y1 ) / 2;

					_canvas.graphics.cubicCurveTo( cx, dy, rankWidth, dy, rankWidth, y1 );

					y1 = moRank.toPercent * hh;

					_canvas.graphics.lineTo( rankWidth, y1 );

					cx = rankWidth;
					y0 = y1;
				}

				// Если последний перепад ширины закончился, а сущность продолжается дальше,
				// ... тогда строим переход к минимальной ширине
				if ( y0 < hh ) {
					y1 = Math.min( y0 + JDUtils.DAYS_PER_YEAR * MoTimeline.me.scale, hh );
					dy = ( y0 + y1 ) / 2;
					rankWidth = minWW;

					_canvas.graphics.cubicCurveTo( cx, dy, rankWidth, dy, rankWidth, y1 );

					// Если после построения перехода, сущность продолжается дальше,
					// ... тогда рисуем прямую линию до конца сущности
					if ( y1 < hh ) {
						y1 = hh;
						_canvas.graphics.lineTo( rankWidth, y1 );
					}
				}

				// Дорисосвываем контур до основания x = 0, а затем закрываем контур
				_canvas.graphics.lineTo( 0, hh );
				_canvas.graphics.lineTo( 0, 0 );
			} else {
				_canvas.graphics.drawRect( 0, 0, Settings.ENT_WIDTH, uint( hh ) );
			}

			_canvas.graphics.endFill();

			rasterize();
			_canvas.graphics.clear();
		}
		
		private function rasterize():void {
			if ( contains( _bmp ) ) removeChild( _bmp );

			addChild(_canvas);

			var mtx:Matrix = new Matrix();
			mtx.identity();
			mtx.translate(0, _offsetY);

			var bmpData:BitmapData = new BitmapData( width, _height, true, 0xff0000 );
			bmpData.draw( _canvas, mtx );
			
			_bmp.bitmapData = bmpData;

			removeChild(_canvas);
			
			addChild( _bmp );
		}

		override public function kill():void
		{
			super.kill();

			_moEntity = null;
		}
	}

}
