package display.components {
	import constants.LocaleString;
	import constants.TextFormats;
	import display.base.TextApp;
	import ru.arslanov.core.utils.DateUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.core.utils.StringUtils;
	import ru.arslanov.flash.display.AShape;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DateGraduation extends ASprite {
		private var _jd:Number = 0;
		private var _width:uint;
		
		private var _label:TextApp;
		private var _line:AShape;
		
		private var _changeLine:Boolean = true;
		private var _changeDate:Boolean = true;
		
		public function DateGraduation( julianDate:Number = 0, width:uint = 100 ) {
			_jd = julianDate;
			_width = width;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			draw();
			
			return this;
		}
		
		public function get julianDate():Number {
			return _jd;
		}
		
		public function set julianDate( value:Number ):void {
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
				_line.graphics.lineStyle( 1, 0x0, 1 );
				_line.graphics.lineTo( _width, 0 );
				
				_changeLine = false;
			}
			
			if ( !_label ) {
				_label = new TextApp( "", TextFormats.DEFAULT ).init();
				addChild( _label );
			}
			
			if ( _changeDate ) {
				var date:Object = DateUtils.JDToDate( _jd );
				_label.text = StringUtils.substitute( LocaleString.DATE_YYYY_MONTH_DD, date.year, DateUtils.getMonthName( date.month ), date.date );
				_label.y = -_label.height;
				
				_changeDate = false;
			}
		}
	}

}