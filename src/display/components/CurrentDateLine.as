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
	public class CurrentDateLine extends ASprite {
		private var _jd:Number = 0;
		private var _width:uint = 100;
		private var _template:String = "";

		private var _label:TextApp;
		private var _line:AShape;

		private var _changeLine:Boolean = true;
		private var _changeDate:Boolean = true;
		private var _colorLine:uint;
		private var _colorText:uint;
		private var _colorBackground:Object;

		public function CurrentDateLine( julianDate:Number, width:uint, template:String = null, colorLine:uint = 0x0, colorText:uint = 0x0, colorBackground:Object = null ) {
			_jd = julianDate;
			_width = width;
			_template = template ? template : _template;
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

		public function reinit( jd:Number, width:uint = 0, template:String = null ):void
		{
			_jd = jd;
			_width = width > 0 ? width : _width;
			_template = template ? template : _template;

			_changeDate = true;
			_changeLine = true;

			draw();
		}
		
		public function get jd():Number {
			return _jd;
		}
		
		public function set jd( value:Number ):void {
			_jd = value;
			
			_changeDate = true;
			
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
			if ( !_line ) {
				_line = new AShape().init();
				addChild( _line );
			}
			
			if ( _changeLine ) {
				_line.graphics.clear();
				_line.graphics.lineStyle( 1, _colorLine, 1 );
				_line.graphics.lineTo( _width, 0 );

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
				_label.text = JDUtils.getFormatString( _jd, _template );
				_label.y = -_label.height;
				
				_changeDate = false;
			}
		}
	}

}