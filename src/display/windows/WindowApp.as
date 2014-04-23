package display.windows {
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.windows.AWindow;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class WindowApp extends AWindow {
		private var _width:int;
		private var _height:int;
		
		public function WindowApp( name:String, width:int = -1, height:int = -1 ) {
			_width = width;
			_height = height;
			
			super( name, null );
		}
		
		override public function init():* {
			var winBody:ASprite = new ASprite().init();
			winBody.graphics.beginFill( 0x534a30, 0.5 );
			winBody.graphics.drawRect( 0, 0, _width > 0 ? _width : 200, _height > 0 ? _height : 167 );
			winBody.graphics.endFill();
			
			super.body = winBody;
			
			return super.init();
		}
	}

}