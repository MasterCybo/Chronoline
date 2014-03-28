package display.gui {
	import collections.EntityManager;
	import display.base.ToggleApp;
	import display.components.RangeEditor;
	import display.gui.buttons.BtnIcon;
	import display.gui.buttons.ToggleIcon;
	import display.windows.WinLegend;
	import events.GuideLineNotice;
	import flash.display.BitmapData;
	import flash.events.Event;
	import net.ReqSavePreset;
	import ru.arslanov.core.events.Notification;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.layout.HBox;
	import ru.arslanov.flash.gui.windows.AWindowsManager;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MainGUI extends ASprite {
		private var _toolbar:HBox;
		private var _body:ABitmap;
		private var _sideBar:SideBar;
		
		public function MainGUI() {
			super();
		}
		
		override public function init():* {
			_body = ABitmap.fromColor( Settings.GUI_COLOR, Display.stageWidth, Settings.TOOLBAR_HEIGHT, false ).init();
			_toolbar = new HBox( 5 ).init();
			
			var rangeEditor:RangeEditor = new RangeEditor().init();
			
			var btnScreenshot:BtnIcon = new BtnIcon( PngBtnScreenshot ).init();
			var btnSave:BtnIcon = new BtnIcon( PngBtnSavePreset ).init();
			var btnLegend:BtnIcon = new BtnIcon( PngBtnLegend ).init();
			var btnGuide:ToggleIcon = new ToggleIcon( PngBtnGuidlineOff, null, PngBtnGuidlineOn ).init();
			
			btnGuide.onRelease = onDisplayGuideLine;
			btnSave.onRelease = hrClickSave;
			btnLegend.onRelease = hrClickLegend;
			
			_toolbar.addChildAndUpdate( btnGuide );
			_toolbar.addChildAndUpdate( btnSave );
			_toolbar.addChildAndUpdate( btnScreenshot );
			_toolbar.addChildAndUpdate( btnLegend );
			
			_sideBar = new SideBar( Display.stageWidth / 2, Display.stageHeight - _body.height ).init();
			
			var winContainer:ASprite = new ASprite();
			
			onStageResize();
			
			addChild( _body );
			addChild( rangeEditor );
			addChild( _toolbar );
			addChild( _sideBar );
			addChild( winContainer );
			
			AWindowsManager.me.init( winContainer );
			
			Display.stageAddEventListener( Event.RESIZE, onStageResize );
			
			return super.init();
		}
		
		private function onDisplayGuideLine( btn:ToggleIcon ):void {
			Notification.send( GuideLineNotice.NAME, new GuideLineNotice( btn.checked )  );
		}
		
		private function hrClickSave():void {
			var ids:Array = [];
			
			var ents:Array = EntityManager.getArrayEntities();
			var len:uint = ents.length;
			
			for ( var i:int = 0; i < len; i++ ) {
				ids.push( ents[ i ].id );
			}
			
			Log.traceText( "ids : " + ids );
			
			App.httpManager.addRequest( new ReqSavePreset( App.currentType, ids ) );
		}
		
		private function hrClickLegend( btn:ToggleApp ):void {
			if ( btn.checked ) {
				AWindowsManager.me.displayWindow( new WinLegend( -1, Display.stageHeight - _body.height ).init() );
			} else {
				AWindowsManager.me.removeWindow( WinLegend.WINDOW_NAME );
			}
		}
		
		private function onStageResize( ev:Event = null ):void {
			_body.bitmapData.dispose();
			_body.bitmapData = new BitmapData( Display.stageWidth, Settings.TOOLBAR_HEIGHT, false, Settings.GUI_COLOR );
			
			_sideBar.y = _body.height;
			_sideBar.width = int( Display.stageWidth / 2 );
			_sideBar.height = Display.stageHeight - _sideBar.y;
			
			if ( _sideBar.isOpened ) {
				_sideBar.x = Display.stageWidth - _sideBar.widthBody;
			} else {
				_sideBar.x = Display.stageWidth;
			}
			
			_toolbar.x = int(( _body.width - _toolbar.width ) / 2 );
			_toolbar.y = int(( _body.height - _toolbar.height ) / 2);
		}
		
		override public function kill():void {
			AWindowsManager.me.removeAllWindows();
			
			super.kill();
		}
	}

}
