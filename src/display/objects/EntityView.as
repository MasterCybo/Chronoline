package display.objects {

	import data.MoEntity;
	import data.MoRankEntity;
	import data.MoTimeline;

	import flash.display.BitmapData;
	import flash.filters.GlowFilter;

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
		private var _color:uint;
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
			graphics.beginFill( _color );

			var ranks:Vector.<MoRankEntity> = _moEntity.ranks;

			if ( ranks.length > 0 ) {
				var minWW:Number = Settings.ENT_WIDTH_MIN;
				var cx:Number = minWW;
				var y0:Number = 0;
				var y1:Number = 0;
				var dy:Number = 0;

				graphics.lineTo( minWW, 0 );

				for ( var i:uint = 0; i<ranks.length; i++ ) {
					var moRank:MoRankEntity = ranks[i];
					var rankWidth:Number = minWW + moRank.rank * minWW;

					y1 = moRank.fromPercent * _height;
					dy = ( y0 + y1 ) / 2;

					graphics.cubicCurveTo( cx, dy, rankWidth, dy, rankWidth, y1 );

					y1 = moRank.toPercent * _height;

					graphics.lineTo( rankWidth, y1 );

					cx = rankWidth;
					y0 = y1;
				}

				// Если последний перепад ширины закончился, а сущность продолжается дальше,
				// ... тогда строим переход к минимальной ширине
				if ( y0 < _height ) {
					y1 = Math.min( y0 + JDUtils.DAYS_PER_YEAR * MoTimeline.me.scale, _height );
					dy = ( y0 + y1 ) / 2;
					rankWidth = minWW;

					graphics.cubicCurveTo( cx, dy, rankWidth, dy, rankWidth, y1 );

					// Если после построения перехода, сущность продолжается дальше,
					// ... тогда рисуем прямую линию до конца сущности
					if ( y1 < _height ) {
						y1 = _height;
						graphics.lineTo( rankWidth, y1 );
					}
				}

				// Дорисосвываем контур до основания x = 0, а затем закрываем контур
//				graphics.lineTo( minWW, _height );
				graphics.lineTo( 0, _height );
				graphics.lineTo( 0, 0 );
			} else {
				graphics.drawRect( 0, 0, Settings.ENT_WIDTH, uint( _height ) );
			}

			graphics.endFill();



			//*/
			// Рисуем тело
			//graphics.beginFill( Settings.ENT_CLR_BODY );
//			graphics.beginFill( _color );
//			graphics.drawRect( 0, 0, Settings.ENT_WIDTH, uint( _height ) );
//			graphics.endFill();
			
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

			var bmpData:BitmapData = new BitmapData( width, height, true, 0xff0000 );
			bmpData.draw( this );
			
			_bmp.bitmapData = bmpData;
			
			addChild( _bmp );
		}

		override public function kill():void
		{
			super.kill();

			_moEntity = null;
		}
	}

}
