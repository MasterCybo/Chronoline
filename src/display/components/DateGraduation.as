package display.components {
	import constants.LocaleString;
	import constants.TextFormats;

	import display.base.TextApp;

	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.flash.display.AShape;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DateGraduation extends ASprite {
//		static public const MODE_GHOST:String = "modeGhost";
//		static public const MODE_GHOST:String = "modeGhost";

		private var _jd:Number = 0;
		private var _width:uint;
		
		private var _label:TextApp;
		private var _line:AShape;
		
		private var _changeLine:Boolean = true;
		private var _changeDate:Boolean = true;
		private var _colorLine:uint;
		private var _colorText:uint;
		
		public function DateGraduation( julianDate:Number = 0, width:uint = 100, colorLine:uint = 0x0, colorText:uint = 0x0 ) {
			_jd = julianDate;
			_width = width;
			_colorLine = colorLine;
			_colorText = colorText;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			draw();
			
			return this;
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
				_label.textColor = _colorText;
				addChild( _label );
			}
			
			if ( _changeDate ) {
				_label.text = JDUtils.getFormatString( _jd, LocaleString.DATE_YYYY_MONTH_DD );
				_label.y = -_label.height;
				
				_changeDate = false;
			}
		}
	}

}