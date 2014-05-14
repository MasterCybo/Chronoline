package display.gui
{
	import collections.EntityManager;

	import display.components.RangeEditor;
	import display.gui.buttons.BtnIcon;
	import display.gui.buttons.ToggleIcon;
	import display.windows.WinLegend;
	import display.windows.WinSavePreset;

	import events.GuideLineNotice;
	import events.SnapshotNotice;

	import flash.display.BitmapData;

	import net.ReqPresetSave;

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
	public class ToolBar extends ASprite
	{
		private var _body:ABitmap;
		private var _slots:HBox;
		private var _rangeEditor:RangeEditor;

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
			var btnSave:BtnIcon = new BtnIcon( PngBtnSavePreset ).init();
			var btnSnapshot:BtnIcon = new BtnIcon( PngBtnScreenshot ).init();
			var btnLegend:ToggleIcon = new ToggleIcon( PngBtnLegendOff, null, PngBtnLegendOn ).init();

			btnGuide.onRelease = onDisplayGuideLine;
			btnSave.onRelease = hrClickSave;
			btnSnapshot.onRelease = onClickSnapshot;
			btnLegend.onRelease = hrClickLegend;

			_slots.addChildAndUpdate( btnGuide );
			_slots.addChildAndUpdate( btnSave );
			_slots.addChildAndUpdate( btnSnapshot );
			_slots.addChildAndUpdate( btnLegend );

			addChild( _body );
			addChild( _rangeEditor );
			addChild( _slots );

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
		private function hrClickSave():void
		{
			Log.traceText( "*execute* ToolBar.hrClickSave" );
			var ids:Array = [];

			var ents:Array = EntityManager.getArrayEntities();
			var len:uint = ents.length;

			for ( var i:int = 0; i < len; i++ ) {
				ids.push( ents[ i ].id );
			}

			Log.traceText( "    ids : " + ids );


			AWindowsManager.me.displayWindow( new WinSavePreset().init() );

//			App.httpManager.addRequest( new ReqPresetSave( ids ) );
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