package {
	import ru.arslanov.core.utils.DateUtils;

	import utils.EntityColorPalette;

	import constants.LocaleString;
	import constants.TextFormats;

	import services.EntitiesDataWebService;
	import services.PresetsWebService;

	import data.MoPreset;

	import display.base.TextApp;
	import display.components.LockScreenProcess;
	import display.components.MessageFullScreen;
	import display.scenes.ChronolinePage;

	import events.BondDisplayNotice;
	import events.BondRemoveNotice;
	import events.GetPositionNotice;
	import events.PresetsListEvent;
	import events.ProcessFinishNotice;
	import events.ProcessStartNotice;
	import events.SelectPresetNotice;
	import events.SysMessageDisplayNotice;

	import flash.events.Event;
	import flash.system.Capabilities;

	import ru.arslanov.core.events.EventManager;
	import ru.arslanov.core.events.Notification;
	import ru.arslanov.core.external.FlashVars;
	import ru.arslanov.core.http.HTTPManager;
	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.core.utils.Stats;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.hints.ATooltipManager;
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
		static public var presetsService:PresetsWebService;
		static public var entityColorPalette:EntityColorPalette;

		private var _stats:Stats;
		private var _tfVersion:TextApp;
		private var _messFullScreen:ASprite;
		private var _onCloseMessage:Function;
		
		public function App() {
			super();
		}
		
		override public function init():* {
			FlashVars.init( stage );
			Display.init( stage, root );
			
			EventManager.tracer( null );
			
			ATextField.textFormatDefault = TextFormats.DEFAULT;
			//ATextField.defaultEmbedFonts = true;
			//ATextField.defaultBorder = true;
			
			Logger.init( this, "right" );
			Log.customTracer = Logger.traceMessage;

			// Устанавливаем локализацию месяцев
			DateUtils.monthsLocale = LocaleString.MONTHS_GENITIVE;
			
			//AWindowsManager.me.init( this );
			ATooltipManager.me.init( this, 15 );

			// Скрываем ненужные сообщения
			Notification.unlog( BondDisplayNotice.NAME );
			Notification.unlog( BondRemoveNotice.NAME );
			Notification.unlog( GetPositionNotice.NAME );


			// Определяем адрес приложения и инициализирем HTTPManager
			var url:String = Display.root.loaderInfo.url;
			url = url != "" ? url.substring( 0, url.lastIndexOf( "/" ) + 1 ) : "";

			// Создаём HTTP-сервис
			httpManager = new HTTPManager( url );
			presetsService = new PresetsWebService( httpManager );

			// Создаём цветовую палитру для сущностей
			entityColorPalette = new EntityColorPalette();

			// Инициализируем экраны
			var sceneContainer:ASprite = new ASprite().init();
			addChild( sceneContainer );
			
			SceneManager.me.init( sceneContainer );
			SceneManager.me.addScene( ChronolinePage, ChronolinePage.SCENE_NAME );
			

			// Если проигрыватель дебажный, тогда отображаем статистику производительности
			if ( Capabilities.isDebugger ) {
				_stats = new Stats();
				addChild( _stats );
			}

			// Отображаем текущую версию сборки
			_tfVersion = new TextApp( "v." + Version.major + "." + Version.minor + "." + Version.build + " - " + Version.timestamp, TextFormats.VERSION ).init();
			_tfVersion.mouseEnabled = false;
			addChild( _tfVersion );
			
			hrResizeStage();
			
			SceneManager.me.displayScene( ChronolinePage.SCENE_NAME );
			
			Notification.add( ProcessStartNotice.NAME, onShowProcess );
			Notification.add( ProcessFinishNotice.NAME, onHideProcess );
			Notification.add( SysMessageDisplayNotice.NAME, onSystemMessage );
			
			Display.stageAddEventListener( Event.RESIZE, hrResizeStage );


			// Загружаем список пресетов. Делаем это, перед тем как определить автозагрузку дефолтного пресета
			presetsService.eventManager.addEventListener( PresetsListEvent.COMPLETE, onPresetsListComplete );
			presetsService.getList();

			return super.init();
		}

		/**
		 * Определяем и загружаем пресет по ID, переданному из HTML.
		 * @param event
		 */
		private function onPresetsListComplete( event:PresetsListEvent ):void
		{
			presetsService.eventManager.removeEventListener( PresetsListEvent.COMPLETE, onPresetsListComplete );

			// Определяем, какой пресет загружать при инициализации приложения
			var autoLoadPresetID:String = FlashVars.getString( "presetID", "" );

			if ( autoLoadPresetID != "" ) {
				var preset:MoPreset = presetsService.getPreset( autoLoadPresetID );

				if( !preset ) return;

				Notification.send( SelectPresetNotice.NAME, new SelectPresetNotice( preset.id ) );

				EntitiesDataWebService.downloadDataEntities( Vector.<String>( preset.listIDs ) );
			}
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
				_stats.x = Display.stageWidth - _stats.width - Settings.NAVBAR_WIDTH;
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
