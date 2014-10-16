package display.components {
	import constants.TextFormats;

	import display.base.TextApp;

	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.flash.display.AShape;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DateLine extends ASprite {
		private var _text:String = "";
		private var _width:uint = 100;
		private var _height:uint = 1;

		private var _label:TextApp;
		private var _body:AShape;

		private var _changeLine:Boolean = true;
		private var _changeDate:Boolean = true;
		private var _colorLine:uint;
		private var _colorText:uint;
		private var _colorBackground:Object;

		public function DateLine( text:String, width:uint, height:uint, colorLine:uint = 0x0, colorText:uint = 0x0, colorBackground:Object = null ) {
			_text = text;
			_width = width;
			_height = height;
			_colorLine = colorLine;
			_colorText = colorText;
			_colorBackground = colorBackground;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			draw();
			
			return this;
		}

		public function reinit( text:String, width:uint = 0 ):void
		{
			_text = text;
			_width = width > 0 ? width : _width;

			_changeDate = true;
			_changeLine = true;

			draw();
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width( value:Number ):void {
			_width = value;
			
			_changeLine = true;
			
			draw();
		}
		
		private function draw():void {
			if ( !_body ) {
				_body = new AShape().init();
				addChild( _body );
			}
			
			if ( _changeLine ) {
				_body.graphics.clear();
				_body.graphics.beginFill( _colorLine );
				_body.graphics.drawRect( 0,0,_width, _height - 1 );
				_body.graphics.endFill();
				
				_changeLine = false;
			}
			
			if ( !_label ) {
				_label = new TextApp( "", TextFormats.DEFAULT ).init();
				if ( _colorBackground ) {
					_label.setBackground( true, uint( _colorBackground ) );
				}
				_label.textColor = _colorText;
				addChild( _label );
			}
			
			if ( _changeDate ) {
//				_label.text = JDUtils.getFormatString( _jd, LocaleString.DATE_YYYY_MONTH_DD );
				_label.text = _text;//JDUtils.getFormatString( _jd, _template );
//				_label.y = -_label.height;
				_label.y = uint( (_body.height - _label.height) / 2 );

				_changeDate = false;
			}
		}
	}

}