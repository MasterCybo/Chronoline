package display.gui
{
	import collections.EntityManager;

	import constants.LocaleString;

	import data.MoTimeline;

	import display.components.RangeEditor;
	import display.gui.buttons.BtnIcon;
	import display.gui.buttons.ToggleIcon;
	import display.windows.WinLegend;
	import display.windows.WinSavePreset;

	import events.GuideLineNotice;
	import events.SnapshotNotice;
	import events.TimelineEvent;

	import flash.display.BitmapData;

	import ru.arslanov.core.events.Notification;
	import ru.arslanov.flash.display.ABitmap;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.layout.HBox;
	import ru.arslanov.flash.gui.windows.AWindowsManager;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ToolBar extends ASprite
	{
		private var _body:ABitmap;
		private var _slots:HBox;
		private var _rangeEditor:RangeEditor;
		private var _btnSave:BtnIcon;

		public function ToolBar()
		{
			super();
		}

		override public function init():*
		{
			_body = ABitmap.fromColor( Settings.GUI_COLOR, Display.stageWidth, Settings.TOOLBAR_HEIGHT, false ).init();
			_slots = new HBox( 5 ).init();
			_rangeEditor = new RangeEditor().init();

			var btnGuide:ToggleIcon = new ToggleIcon( PngBtnGuidlineOff, null, PngBtnGuidlineOn ).init();
			_btnSave = new BtnIcon( PngBtnSavePreset ).init();
			var btnSnapshot:BtnIcon = new BtnIcon( PngBtnScreenshot ).init();
			var btnLegend:ToggleIcon = new ToggleIcon( PngBtnLegendOff, null, PngBtnLegendOn ).init();

			btnGuide.textTootip = LocaleString.TOOLTIP_MARKER;
			_btnSave.textTootip = LocaleString.TOOLTIP_SAVE_PRESET;
			btnSnapshot.textTootip = LocaleString.TOOLTIP_SCREENSHOT;
			btnLegend.textTootip = LocaleString.TOOLTIP_LEGEND;

			btnGuide.onRelease = onDisplayGuideLine;
			_btnSave.onRelease = hrClickSave;
			btnSnapshot.onRelease = onClickSnapshot;
			btnLegend.onRelease = hrClickLegend;

			_slots.addChildAndUpdate( btnGuide );
			_slots.addChildAndUpdate( _btnSave );
			_slots.addChildAndUpdate( btnSnapshot );
			_slots.addChildAndUpdate( btnLegend );

			addChild( _body );
			addChild( _rangeEditor );
			addChild( _slots );

			checkSaveButton();

			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, checkSaveButton );

			return super.init();
		}

		/**
		 * Сделать и сохранить скриншот
		 */
		private function onClickSnapshot():void
		{
			Notification.send( SnapshotNotice.NAME );
		}

		/**
		 * Показать/скрыть направляющую
		 * @param btn
		 */
		private function onDisplayGuideLine( btn:ToggleIcon ):void
		{
			Notification.send( GuideLineNotice.NAME, new GuideLineNotice( btn.checked ) );
		}

		/**
		 * Сохранение набора
		 */
		public function checkSaveButton( event:TimelineEvent = null ):void
		{
			var ents:Array = EntityManager.getArrayEntities();
			_btnSave.enabled = ents.length > 0;
		}
		private function hrClickSave():void
		{
			AWindowsManager.me.displayWindow( new WinSavePreset( onPressOk, onPressCancel ).init() );
		}

		private function onPressCancel():void
		{
			AWindowsManager.me.removeWindow( WinSavePreset.WINDOW_NAME );
		}

		private function onPressOk( presetName:String ):void
		{
			var ids:Array = [];

			var ents:Array = EntityManager.getArrayEntities();
			var len:uint = ents.length;

			for ( var i:int = 0; i < len; i++ ) {
				ids.push( ents[ i ].id );
			}

			App.presetsService.save( presetName, ids );

			AWindowsManager.me.removeWindow( WinSavePreset.WINDOW_NAME );
		}

		/**
		 * Показать/скрыть окно легенды
		 * @param btn
		 */
		private function hrClickLegend( btn:ToggleIcon ):void
		{
			if ( btn.checked ) {
				AWindowsManager.me.displayWindow( new WinLegend( -1, Display.stageHeight - _body.height ).init() );
			} else {
				AWindowsManager.me.removeWindow( WinLegend.WINDOW_NAME );
			}
		}

		public function updateSize():void
		{
			_body.bitmapData.dispose();
			_body.bitmapData = new BitmapData( Display.stageWidth, Settings.TOOLBAR_HEIGHT, false, Settings.GUI_COLOR );

			_slots.x = int( ( _body.width - _slots.width ) / 2 );
			_slots.y = int( ( _body.height - _slots.height ) / 2 );

			_rangeEditor.x = _rangeEditor.y = int( ( _body.height - _rangeEditor.height ) / 2 );
		}
	}

}