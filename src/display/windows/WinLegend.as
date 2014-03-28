package display.windows {
	import ru.arslanov.flash.gui.windows.AWindowsManager;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class WinLegend extends WindowApp {
		
		static public const WINDOW_NAME:String = "winLegend";
		
		public function WinLegend( width:int = -1, height:int = -1 ) {
			super( WINDOW_NAME, width, height );
		}
		
		override public function init() : * {
			//super.width = 417;
			//super.height = 167;
			super.alignPosition = AWindowsManager.POSITION_RB;
			
			return super.init();
		}
	}

}