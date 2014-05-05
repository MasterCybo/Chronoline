/**
 * Created by aa on 05.05.2014.
 */
package display.components
{
	import data.MoETag;

	import display.base.ExternalPicture;

	import ru.arslanov.flash.gui.ALabel;

	public class ItemLegend extends ALabel
	{
		private var _etag:MoETag;
		private var _handlerDrawComplete:Function;
		private var _imgWidth:int;
		private var _imgHeight:int;
		private var _extPic:ExternalPicture;

		public function ItemLegend( etag:MoETag, imgWidth:int = -1, imgHeight:int = -1, handlerDrawComplete:Function = null )
		{
			_etag = etag;
			_imgWidth = imgWidth;
			_imgHeight = imgHeight;
			_handlerDrawComplete = handlerDrawComplete;
			super( etag.name );
		}



		override public function init():*
		{
			_extPic = new ExternalPicture( Settings.URL_ICONS + encodeURI( _etag.imageURL ), onDrawComplete ).init();

			return super.init();
		}

		private function onDrawComplete():void
		{
			if ( _imgWidth != -1 ) {
				_extPic.scaleX =_imgWidth / _extPic.width;
			}

			if ( _imgHeight != -1 ) {
				_extPic.scaleY =_imgHeight / _extPic.height;
			}

			_extPic.width = uint(_extPic.width);
			_extPic.height = uint(_extPic.height);

			super.setImage( _extPic, 10 );

			if ( _handlerDrawComplete != null ) {
				if ( _handlerDrawComplete.length ) {
					_handlerDrawComplete( this );
				} else {
					_handlerDrawComplete();
				}

			}
		}


		override public function kill():void
		{
			_extPic.kill();
			_handlerDrawComplete = null;
			_etag = null;

			super.kill();
		}
	}
}
