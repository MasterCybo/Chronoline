package display.components
{
	import data.MoPicture;

	import display.base.ExternalPicture;

	import ru.arslanov.core.utils.Calc;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class FactIcon extends ExternalPicture
	{

		private var _rank:uint; // Расштаб иконки 0-100%
		private var _drawCompleteHandler:Function;

		public function FactIcon( moPicture:MoPicture, rank:uint = 0, drawCompleteHandler:Function = null )
		{
			_rank = Calc.constrain( Settings.MIN_RANK, rank, Settings.MAX_RANK );

			_drawCompleteHandler = drawCompleteHandler;

			super( Settings.URL_ICONS + encodeURI( moPicture.filename ), onDrawComplete );
		}

//		override public function init():* {
//			scaleX = scaleY = _rank * 0.01;
//			
//			return super.init();
//		}

		private function onDrawComplete():void
		{
//			super.setSize( width, height, true );
			super.setSize( Settings.ICON_SIZE * _rank * 0.01, Settings.ICON_SIZE * _rank * 0.01, false );

			if ( _drawCompleteHandler == null ) {
				return;
			}

			if ( _drawCompleteHandler.length ) {
				_drawCompleteHandler( this );
			} else {
				_drawCompleteHandler();
			}
		}

		override public function kill():void
		{
			_drawCompleteHandler = null;
			super.kill();
		}
	}

}
