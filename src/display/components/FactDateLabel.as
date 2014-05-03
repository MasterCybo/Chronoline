package display.components {
	import constants.LocaleString;
	import constants.TextFormats;

	import display.base.TextApp;

	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author ...
	 */
	public class FactDateLabel extends ASprite {
		
		static public const PADDING:Number = 3;
		
		private var _jd:Number;
		private var _offsetY:int;
		private var _bmp:ABitmap;
		private var _canvas:ASprite;
		private var _tfLabel:TextApp;
		
		public function FactDateLabel( jd:Number, offsetY:int = 0 ) {
			_jd = jd;
			_offsetY = offsetY;
			super();
		}
		
		override public function init():* {
			super.init();
			
			mouseEnabled = mouseChildren = false;
			
			_canvas = new ASprite().init();
			
			var text:String = JDUtils.getFormatString( _jd, LocaleString.DATE_FULL_FORMAT );
			
			_tfLabel = new TextApp( text, TextFormats.DATE_LABEL ).init();
			_canvas.addChild( _tfLabel );
			
			draw();
			
			return this;
		}
		
		public function get offsetY():int {
			return _offsetY;
		}
		
		public function set offsetY( value:int ):void {
			_offsetY = value;
			
			draw();
		}
		
		public function getHeightLabel():Number {
			return _tfLabel.height + 2 * PADDING;
		}
		
		private function draw():void {
			if ( _bmp ) _bmp.kill();
			
			var pad2:Number = 2 * PADDING;
			var h05:Number =  ( _tfLabel.height + pad2 ) * 0.5;
			var ww:Number = _tfLabel.width + pad2;
			
			_canvas.graphics.clear();
			
			with ( _canvas ) {
				graphics.beginFill( Settings.FACT_CLR_OVER );
				graphics.moveTo( 0, -h05 + _offsetY );
				graphics.lineTo( ww, -h05 + _offsetY );
				graphics.lineTo( ww + h05, 0 );
				graphics.lineTo( ww, h05 + _offsetY );
				graphics.lineTo( 0, h05 + _offsetY );
				graphics.lineTo( 0, -h05 + _offsetY );
				graphics.endFill();
			}
			
			_tfLabel.setXY( PADDING, -h05 + PADDING + _offsetY );
			
			_bmp = ABitmap.fromDisplayObject( _canvas, { transparent:true } ).init();
			
			if ( _offsetY < 0 ) {
				_bmp.y = -_bmp.height;
			} else if ( _offsetY > 0 ) {
				_bmp.y = 0;
			} else {
				_bmp.y = -int( _bmp.height * 0.5 );
			}
			
			//_bmp.y = _offsetY < 0 ? -_bmp.height : 0;
			addChild( _bmp );
		}
	}

}