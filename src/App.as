package {
	import constants.LocaleString;
	import constants.TextFormats;
	import data.MoTimeline;
	import display.base.TextApp;
	import display.components.LockScreenProcess;
	import display.components.MessageFullScreen;
	import display.scenes.ChronolinePage;
	import events.BondDisplayNotice;
	import events.BondRemoveNotice;
	import events.GetPositionNotice;
	import events.ProcessFinishNotice;
	import events.ProcessStartNotice;
	import events.SysMessageDisplayNotice;
	import flash.events.Event;
	import flash.system.Capabilities;
	import ru.arslanov.core.events.EventManager;
	import ru.arslanov.core.events.Notification;
	import ru.arslanov.core.http.HTTPManager;
	import ru.arslanov.core.utils.DateUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.core.utils.Stats;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.hints.AHintManager;
	import ru.arslanov.flash.scenes.SceneManager;
	import ru.arslanov.flash.text.ATextField;
	import ru.arslanov.flash.utils.Display;
	import ru.arslanov.flash.utils.Logger;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class App extends ASprite {
		
		static public var httpManager:HTTPManager;
		static public var currentType:String;
		
		private var _stats:Stats;
		private var _tfVersion:TextApp;
		private var _messFullScreen:ASprite;
		private var _onCloseMessage:Function;
		
		public function App() {
			super();
		}
		
		override public function init():* {
			Display.init( stage, root );
			
			EventManager.tracer( null );
			
			ATextField.textFormatDefault = TextFormats.DEFAULT;
			
			Logger.init( this, "right" );
			Log.customTracer = Logger.traceMessage;
			//Logger.show();
			
			// Устанавливаем локализацию месяцев
			DateUtils.monthsLocale = LocaleString.MONTHS;
			
			//AWindowsManager.me.init( this );
			AHintManager.me.init( this, 15 );
			//ATextField.defaultEmbedFonts = true;
			//ATextField.defaultBorder = true;
			
			Notification.unlog( BondDisplayNotice.NAME );
			Notification.unlog( BondRemoveNotice.NAME );
			Notification.unlog( GetPositionNotice.NAME );
			
			MoTimeline.me.init(); // Инициализация временной шкалы
			
			var sceneContainer:ASprite = new ASprite().init();
			addChild( sceneContainer );
			
			SceneManager.me.init( sceneContainer );
			//SceneManager.me.addScene( MainPage, MainPage.SCENE_NAME );
			SceneManager.me.addScene( ChronolinePage, ChronolinePage.SCENE_NAME );
			
			// Определяем адрес приложения и инициализирем HTTPManager
			var url:String = Display.root.loaderInfo.url;
			url = url != "" ? url.substring( 0, url.lastIndexOf( "/" ) + 1 ) : "";
			
			httpManager = new HTTPManager( url );
			
			if ( Capabilities.isDebugger ) {
				_stats = new Stats();
				addChild( _stats );
			}
			
			_tfVersion = new TextApp( "v." + Version.Major + "." + Version.Minor + "." + Version.Build + " - " + Version.Timestamp, TextFormats.VERSION ).init();
			_tfVersion.mouseEnabled = false;
			addChild( _tfVersion );
			
			hrResizeStage();
			
			//SceneManager.me.displayScene( MainPage.SCENE_NAME );
			SceneManager.me.displayScene( ChronolinePage.SCENE_NAME );
			
			Notification.add( ProcessStartNotice.NAME, onShowProcess );
			Notification.add( ProcessFinishNotice.NAME, onHideProcess );
			Notification.add( SysMessageDisplayNotice.NAME, onSystemMessage );
			
			Display.stageAddEventListener( Event.RESIZE, hrResizeStage );
			
			return super.init();
		}
		
		private function onSystemMessage( notice:SysMessageDisplayNotice ):void {
			_onCloseMessage = notice.handlerAfterClose;
			displayFullScreenMessage( new MessageFullScreen( Display.stageWidth, Display.stageHeight, notice.message, removeFullScreenMessage ).init() );
		}
		
		private function onShowProcess():void {
			displayFullScreenMessage( new LockScreenProcess( Display.stageWidth, Display.stageHeight ).init() );
		}
		
		private function onHideProcess():void {
			removeFullScreenMessage();
		}
		
		private function displayFullScreenMessage( displayObject:ASprite ):void {
			removeFullScreenMessage();
			
			_messFullScreen = displayObject;
			
			addChild( _messFullScreen );
		}
		
		private function removeFullScreenMessage():void {
			if ( !_messFullScreen ) return;
			
			_messFullScreen.kill();
			_messFullScreen = null;
			
			if ( _onCloseMessage != null ) {
				var fn:Function = _onCloseMessage;
				_onCloseMessage = null;
				fn();
			}
		}
		
		private function hrResizeStage( ev:Event = null ):void {
			if ( _stats ) {
				_stats.x = Display.stageWidth - _stats.width;
				_stats.y = Display.stageHeight - _stats.height;
			}
			
			if ( _messFullScreen ) {
				_messFullScreen.width = Display.stageWidth;
				_messFullScreen.height = Display.stageHeight;
			}
			
			_tfVersion.x = int(( Display.stageWidth - _tfVersion.width ) / 2 );
			_tfVersion.y = Display.stageHeight - _tfVersion.height;
		}
	
	}

}
