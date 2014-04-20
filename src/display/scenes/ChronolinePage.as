package display.scenes {
	import by.blooddy.crypto.image.JPEGEncoder;
	import collections.EntityColor;
	import collections.EntityManager;
	import controllers.DesktopController;
	import data.MoTimeline;
	import display.components.GuideLine;
	import display.gui.Desktop;
	import display.gui.MainGUI;
	import events.GuideLineNotice;
	import events.ServerDataCompleteNotice;
	import events.SnapshotNotice;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import ru.arslanov.core.events.Notification;
	import ru.arslanov.core.utils.JDUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.core.utils.StringUtils;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.scenes.AScene;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ChronolinePage extends AScene {
		static public const SCENE_NAME:String = "chronolinePage";
		
		//private var _rulerGlobal:RulerGlobal;
		private var _desktop:Desktop;
		private var _deskCtrl:DesktopController;
		private var _guideLine:GuideLine;
		
		public function ChronolinePage() {
			super( SCENE_NAME );
		}
		
		override public function init():* {
			var gui:MainGUI = new MainGUI().init();
			
			//_rulerGlobal = new RulerGlobal( hh ).init();
			//_rulerGlobal.y = gui.y + Settings.TOOLBAR_HEIGHT;
			
			_desktop = new Desktop( Display.stageWidth, Display.stageHeight - Settings.TOOLBAR_HEIGHT ).init();
			//_desktop.x = Settings.DESK_OFFSET;
			_desktop.y = Settings.TOOLBAR_HEIGHT;
			
			_guideLine = new GuideLine( _desktop.width ).init();
			
			addChild( _desktop );
			addChild( _guideLine );
			//addChild( _rulerGlobal );
			addChild( gui );
			
			_deskCtrl = new DesktopController( _desktop );
			_deskCtrl.init();
			
			Notification.add( ServerDataCompleteNotice.NAME, onUpdateChronoline );
			Notification.add( GuideLineNotice.NAME, onDisplayHelper );
			Notification.add( SnapshotNotice.NAME, onSnapshot );
			
			Display.stageAddEventListener( Event.RESIZE, hrResizeStage );
			
			return super.init();
		}
		
		private function onSnapshot():void {
			var snapshot:ABitmap = ABitmap.fromDisplayObject( _desktop );
			var bytes:ByteArray = JPEGEncoder.encode( snapshot.bitmapData, 100 );
			
			var dateStamp:Date = new Date();
			var fname:String = "chronoline_" 
								+ dateStamp.fullYear 
								+ "-" + StringUtils.numberToString( dateStamp.month + 1 ) 
								+ "-" + StringUtils.numberToString( dateStamp.date )
								+ "_" + StringUtils.numberToString( dateStamp.hours )
								+ "-" + StringUtils.numberToString( dateStamp.minutes )
								+ "-" + StringUtils.numberToString( dateStamp.seconds )
								+ ".jpg";
			
			var file:FileReference = new FileReference();
			file.save( bytes, fname );
		}
		
		private function onDisplayHelper( notice:GuideLineNotice ):void {
			if ( notice.visible ) {
				_guideLine.x = _desktop.x;
				_guideLine.visible = true;
				Display.stageAddEventListener( MouseEvent.MOUSE_MOVE, onMoveHelper );
			} else {
				_guideLine.visible = false;
				Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onMoveHelper );
			}
		}
		
		private function onMoveHelper( ev:MouseEvent ):void {
			var yCenter:Number = (_desktop.y + Display.stageHeight) / 2;
			var dy:Number = ev.stageY - yCenter;
			
			var curJD:Number = MoTimeline.me.baseJD + dy / MoTimeline.me.scale;
			
			var gdate:Object = JDUtils.JDNToDate( curJD );
			_guideLine.textLabel = StringUtils.substitute( "{2}.{1}.{0}"
										, StringUtils.numberToString( gdate.date )
										//, DateUtils.getMonthName( gdate.month )
										, StringUtils.numberToString( gdate.month )
										, gdate.year);
			
			_guideLine.y = Display.mouseY;
		}
		
		private function onUpdateChronoline():void {
			Log.traceText( "*execute* ChronolinePage.onUpdateChronoline" );
			
			EntityColor.reset();
			
			Log.traceText( "EntityManager.period.duration : " + EntityManager.period.duration );
			
			var initScale:Number = (Display.stageHeight - Settings.TOOLBAR_HEIGHT) / EntityManager.period.duration;
			var centralJD:Number = (EntityManager.period.beginJD + EntityManager.period.endJD ) / 2;
			
			MoTimeline.me.init( EntityManager.period.beginJD, EntityManager.period.endJD, centralJD, initScale );
			
			//var minScale:Number = (Display.stageHeight - Settings.TOOLBAR_HEIGHT) / MoTimeline.me.duration;
			
			//MoTimeline.me.scale = minScale;
			
			//Log.traceText( "minScale : " + minScale );
			
			//var maxScale:Number = MoTimeline.me.duration / (Display.stageHeight - Settings.TOOLBAR_HEIGHT);
			//Log.traceText( "maxScale : " + maxScale );
			
			//_desktop.update();
		}
		
		private function hrResizeStage( ev:Event ):void {
			//_rulerGlobal.height = Display.stageHeight - _rulerGlobal.y;
			_desktop.height = Display.stageHeight - Settings.TOOLBAR_HEIGHT;
			
			var ww:Number = Display.stageWidth - _desktop.x;
			
			if ( ww != _desktop.width ) {
				_desktop.width = ww;
				_guideLine.width = ww;
			}
		}
		
		override public function kill():void {
			Display.stageRemoveEventListener( Event.RESIZE, hrResizeStage );
			
			_deskCtrl.dispose();
			
			super.kill();
		}
	}

}