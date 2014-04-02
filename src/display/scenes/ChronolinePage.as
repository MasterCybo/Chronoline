package display.scenes {
	import collections.EntityColor;
	import collections.EntityManager;
	import controllers.DesktopController;
	import data.MoDate;
	import data.MoTimeline;
	import display.components.DebugPanel;
	import display.components.GuideLine;
	import display.gui.Desktop;
	import display.gui.MainGUI;
	import display.gui.RulerGlobal;
	import events.GuideLineNotice;
	import events.ServerDataCompleteNotice;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ru.arslanov.core.events.Notification;
	import ru.arslanov.core.utils.DateUtils;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.core.utils.StringUtils;
	import ru.arslanov.flash.scenes.AScene;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ChronolinePage extends AScene {
		static public const SCENE_NAME:String = "chronolinePage";
		static public const TIME_STEP:Number = 50;
		
		private var _rulerGlobal:RulerGlobal;
		private var _desktop:Desktop;
		private var _deskCtrl:DesktopController;
		private var _guideLine:GuideLine;
		
		public function ChronolinePage() {
			super( SCENE_NAME );
		}
		
		override public function init():* {
			var gui:MainGUI = new MainGUI().init();
			
			var hh:uint = Display.stageHeight - Settings.TOOLBAR_HEIGHT;
			
			_rulerGlobal = new RulerGlobal( hh ).init();
			_rulerGlobal.y = gui.y + Settings.TOOLBAR_HEIGHT;
			
			_desktop = new Desktop( Display.stageWidth - _rulerGlobal.width, hh ).init();
			_desktop.x = _rulerGlobal.x + _rulerGlobal.width + Settings.DESK_OFFSET;
			_desktop.y = _rulerGlobal.y;
			
			_guideLine = new GuideLine( _desktop.width ).init();
			
			addChild( _desktop );
			addChild( _guideLine );
			addChild( _rulerGlobal );
			addChild( gui );
			
			_deskCtrl = new DesktopController( _desktop );
			_deskCtrl.init();
			
			var debugPanel:DebugPanel = new DebugPanel().init();
			debugPanel.setXY( 100 + Math.random() * 200, 50 + Math.random() * 100 );
			addChild( debugPanel );
			
			Notification.add( ServerDataCompleteNotice.NAME, onUpdateChronoline );
			Notification.add( GuideLineNotice.NAME, onDisplayHelper );
			
			Display.stageAddEventListener( Event.RESIZE, hrResizeStage );
			
			return super.init();
		}
		
		private function onDisplayHelper( notice:GuideLineNotice ):void {
			if ( notice.visible ) {
				_guideLine.x = _desktop.x;
				_guideLine.visible = true;
				Display.stageAddEventListener( MouseEvent.MOUSE_MOVE, hrMoveMouse );
			} else {
				_guideLine.visible = false;
				Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, hrMoveMouse );
			}
		}
		
		private function hrMoveMouse( ev:MouseEvent ):void {
			//var rDur:Number = MoTimeline.me.rangeEnd.jd - MoTimeline.me.rangeBegin.jd;
			//var kd:Number = rDur / ( Display.stageHeight - _desktop.y );
			//var year:Number = Math.round( MoTimeline.me.rangeBegin.jd + ( Display.mouseY - _desktop.y ) * kd );
			//_guideLine.textLabel = year;
			
			var rDur:Number = MoTimeline.me.rangeEnd.jd - MoTimeline.me.rangeBegin.jd;
			var kd:Number = rDur / ( Display.stageHeight - _desktop.y );
			var curJD:Number = MoTimeline.me.rangeBegin.jd + ( Display.mouseY - _desktop.y ) * kd;
			
			var gdate:Object = DateUtils.JDNToDate( curJD );
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
			
			var dateBegin:MoDate = new MoDate();
			var dateEnd:MoDate = new MoDate();
			
			Log.traceText( "EntityManager.period.duration : " + EntityManager.period.duration );
			
			if ( EntityManager.period.duration > 0 ) {
				dateBegin.jd = EntityManager.period.dateBegin.jd;
				dateEnd.jd = EntityManager.period.dateEnd.jd;
			}
			
			Log.traceText( "dateBegin : " + dateBegin );
			Log.traceText( "dateEnd : " + dateEnd );
			
			
			var abc:Number = 50 * 365;
			
			var dateBeginJD:Number = Math.floor(dateBegin.jd / abc) * abc;
			var dateEndJD:Number = Math.ceil(dateEnd.jd / abc) * abc;
			
			Log.traceText( "dateBeginJD : " + dateBeginJD );
			Log.traceText( "dateEndJD : " + dateEndJD );
			
			//var delta:Number = Math.floor(dateEnd.jd - dateBegin.jd) * 0.1;
			//MoTimeline.me.setTimePeriod( dateBegin.jd - delta, dateEnd.jd + delta ); // HACK: ручная установка 
			MoTimeline.me.setTimePeriod( dateBeginJD, dateEndJD ); // HACK: ручная установка 
			MoTimeline.me.setRange( dateBegin.jd, dateEnd.jd );
			
			//_desktop.update();
		}
		
		private function hrResizeStage( ev:Event ):void {
			_rulerGlobal.height = Display.stageHeight - _rulerGlobal.y;
			_desktop.height = Display.stageHeight - _rulerGlobal.y;
			
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