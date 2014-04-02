package display.gui {
	import flash.events.Event;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.windows.AWindowsManager;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MainGUI extends ASprite {
		private var _toolbar:ToolBar;
		private var _sideBar:SideBar;
		private var _navBar:NavigationBar;
		
		public function MainGUI() {
			super();
		}
		
		override public function init():* {
			_toolbar = new ToolBar().init();
			_sideBar = new SideBar( Display.stageWidth / 2, Display.stageHeight - Settings.TOOLBAR_HEIGHT ).init();
			_navBar = new NavigationBar().init();
			
			var winContainer:ASprite = new ASprite();
			
			onStageResize();
			
			addChild( _toolbar );
			addChild( _navBar );
			addChild( _sideBar );
			addChild( winContainer );
			
			AWindowsManager.me.init( winContainer );
			
			Display.stageAddEventListener( Event.RESIZE, onStageResize );
			
			return super.init();
		}
		
		private function onStageResize( ev:Event = null ):void {
			_sideBar.y = Settings.TOOLBAR_HEIGHT;
			_sideBar.width = int( Display.stageWidth / 2 );
			_sideBar.height = Display.stageHeight - _sideBar.y;
			
			if ( _sideBar.isOpened ) {
				_sideBar.x = Display.stageWidth - _sideBar.widthBody;
			} else {
				_sideBar.x = Display.stageWidth;
			}
			
			_toolbar.updateSize();
			_toolbar.x = int((  Display.stageWidth - _toolbar.width ) / 2 );
			
			_navBar.x = Display.stageWidth - _navBar.width;
			_navBar.y = int((Display.stageHeight - Settings.TOOLBAR_HEIGHT - _navBar.height ) / 2);
		}
		
		override public function kill():void {
			AWindowsManager.me.removeAllWindows();
			
			super.kill();
		}
	}

}
