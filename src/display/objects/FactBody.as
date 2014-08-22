package display.objects
{

	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;

	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.AShape;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.GraphicsUtils;

	/**
	 * Изображение события на сущности
	 * @author Artem Arslanov
	 */
	public class FactBody extends ASprite
	{

		static public const X_CENTER:Number = 0.5 * Settings.ENT_WIDTH;

		static private var _cache:Dictionary /*BitmapData*/ = new Dictionary( true ); // _color + "_" + height = BitmapData

		private var _bmp:ABitmap;
		private var _canvas:AShape;
		private var _height:Number;
		private var _color:uint = Settings.FACT_CLR;
		private var _thickness:uint = Settings.FACT_LINE_THIK_NORMAL;
		private var _alpha:Number = Settings.FACT_LINE_ALPHA;

		public function FactBody( height:Number = 100 )
		{
			_height = height;

			super();
		}

		override public function init():*
		{
			super.init();

			_bmp = new ABitmap().init();
			addChild( _bmp );

			_canvas = new AShape().init();

			draw();

			mouseEnabled = mouseChildren = false;

			return this;
		}

		public function set stateOver( value:Boolean ):void
		{
			if ( value == ( _alpha == 1 ) ) return;

			if ( value ) {
				_color = Settings.FACT_CLR_OVER;
				_thickness = Settings.FACT_LINE_THIK_OVER;
				_alpha = 1;
			} else {
				_color = Settings.FACT_CLR;
				_thickness = Settings.FACT_LINE_THIK_NORMAL;
				_alpha = Settings.FACT_LINE_ALPHA;
			}

			draw();
		}

		override public function set height( value:Number ):void
		{
			if ( value == _height ) return;

			_height = Math.max( Settings.FACT_LINE_THIK_NORMAL, uint( value ) );

			draw();
		}

		override public function get height():Number
		{
			return uint( _height );
		}

		/***************************************************************************
		 Рисуем вешку
		 ***************************************************************************/
		private function draw():void
		{
			var token:String = getToken();

			Log.traceText( "*execute* FactBody.draw : " + token );

			var bd:BitmapData = _cache[ token ];

			if ( !bd ) {
				//Log.traceText( "_alpha : " + _alpha );
				//_canvas.graphics.lineStyle( _thickness, _color, _alpha, true, LineScaleMode.NONE, CapsStyle.NONE );
				_canvas.graphics.lineStyle(
						Settings.FACT_LINE_THIK_NORMAL,
						_color,
						_alpha,
						true,
						LineScaleMode.NONE,
						CapsStyle.NONE
				);
				_canvas.graphics.moveTo( 0, 0 );

				if ( height <= Settings.FACT_LINE_THIK_NORMAL ) {
					_canvas.graphics.lineTo( Settings.ENT_WIDTH + Settings.TAIL_LENGTH, 0 );
				} else {
					if ( _alpha != 1 ) {
						GraphicsUtils.drawDash( _canvas.graphics, X_CENTER, 0, X_CENTER, height, 5, 2 );
					} else {
						_canvas.graphics.lineStyle(
								_thickness,
								_color,
								_alpha,
								true,
								LineScaleMode.NONE,
								CapsStyle.NONE
						);
						_canvas.graphics.moveTo( X_CENTER, 0 );
						_canvas.graphics.lineTo( X_CENTER, height );
					}

					_canvas.graphics.lineStyle(
							Settings.FACT_LINE_THIK_NORMAL,
							_color,
							_alpha,
							true,
							LineScaleMode.NONE,
							CapsStyle.NONE
					);

					_canvas.graphics.moveTo( 0, 0 );
					_canvas.graphics.lineTo( Settings.ENT_WIDTH, 0 );

					_canvas.graphics.moveTo( X_CENTER, height * 0.5 );
					_canvas.graphics.lineTo( Settings.ENT_WIDTH + Settings.TAIL_LENGTH, height * 0.5 );

					_canvas.graphics.moveTo( 0, height );
					_canvas.graphics.lineTo( Settings.ENT_WIDTH, height );
				}

//				Log.traceText( "_canvas.width x height : " + _canvas.width + " x " + _canvas.height );

				bd = new BitmapData( uint( _canvas.width ), uint( _canvas.height ), true, 0x00ff0000 );
				bd.draw( _canvas );

				//Log.traceText( "Added to Pool : " + key );

				_cache[ token ] = bd;

				_canvas.graphics.clear();
			}

			_bmp.bitmapData = bd;
		}

		public function getToken():String
		{
			return height + "_" + "0x" + _color.toString( 16 );
		}

		override public function kill():void
		{
			delete _cache[getToken()];
			_canvas.kill();

			super.kill();
		}
	}

}
