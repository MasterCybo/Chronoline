package display.components
{
	import collections.tree.ItemOfList;
	import collections.tree.TreeList;

	import constants.LocaleString;
	import constants.TextFormats;
	import constants.TreeListType;

	import data.MoListEntity;
	import data.MoListPartition;
	import data.MoPreset;

	import display.base.TextApp;
	import display.gui.buttons.ButtonText;

	import events.PresetSaveEvent;
	import events.PresetsListEvent;
	import events.SelectPresetNotice;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	import net.ReqPartEntities;
	import net.ReqPartitions;

	import ru.arslanov.core.events.Notification;
	import ru.arslanov.flash.display.ASprite;

	import services.EntitiesDataWebService;

	import utils.ParserEntities;
	import utils.ParserPartitions;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DisplayMenuSettings extends ASprite
	{
		static private var _vectItems:Vector.<ItemOfList>; // Массив элементов списка

		private var _width:uint;
		private var _height:uint;

		private var _tfOrigin:TextApp;
		private var _tfTarget:TextApp;
		private var _tfPresets:TextApp;
		private var _originView:ViewTreeList;
		private var _targetView:ViewTreeList;
		private var _presetsView:ViewTreeList;
		private var _btnReady:ButtonText;

		private var _originList:TreeList;
		private var _displayList:TreeList;
		private var _presetsList:TreeList;
		// temp

		public function DisplayMenuSettings( width:uint, height:uint )
		{
			_width = width;
			_height = height;

			super();
		}

		override public function init():*
		{
			_originList = new TreeList( TreeListType.ORIGIN_LIST );
			_displayList = new TreeList( TreeListType.DISPLAY_LIST );
			_presetsList = new TreeList( TreeListType.PRESET_LIST );

			// Заголовки списков
			_tfOrigin = new TextApp( LocaleString.TITLE_ORIGIN, TextFormats.LIST_HEADER ).init();
			_tfTarget = new TextApp( LocaleString.TITLE_DISPLAY, TextFormats.LIST_HEADER ).init();
			_tfPresets = new TextApp( LocaleString.TITLE_PRESETS, TextFormats.LIST_HEADER ).init();

			// Список каталога сущностей
			_originView = new ViewTreeList( _width, _height / 2 - 5 ).init();
			_originView.eventManager.addEventListener( MouseEvent.CLICK, onClickOriginal );

			// Список пресетов
			_presetsView = new ViewTreeList( _width, _height / 2 - 5 ).init();
			_presetsView.eventManager.addEventListener( MouseEvent.CLICK, onClickPreset );

			// Список выбранных сущностей
			_targetView = new ViewTreeList( _width, _height ).init();
			_targetView.eventManager.addEventListener( MouseEvent.CLICK, onClickTarget );

			// Кнопка визуализации выбранных сущностей
			_btnReady = new ButtonText( LocaleString.DISPLAY_SELECTED ).init();
			_btnReady.onRelease = onReleaseReady;

			updateSize();

			addChild( _originView );
			addChild( _targetView );
			addChild( _presetsView );
			addChild( _tfOrigin );
			addChild( _tfTarget );
			addChild( _tfPresets );


			App.presetsService.eventManager.addEventListener( PresetsListEvent.COMPLETE, onPresetsListComplete );
			App.presetsService.eventManager.addEventListener( PresetSaveEvent.COMPLETE, onPresetSaveComplete );

			Notification.add( SelectPresetNotice.NAME, onSelectPreset );

			sendPartsRequest();

			return super.init();
		}

		/**
		 * Добавляем пресет в целевой список по событию
		 * @param notice
		 */
		private function onSelectPreset( notice:SelectPresetNotice ):void
		{
			var list:Dictionary = _presetsList.rootChildren;

			var moPreset:MoPreset;
			var item:ItemOfList;

			for each ( item in list ) {
				moPreset = item.dataObject as MoPreset;

				if ( moPreset.id == notice.presetID ) {
					break;
				}

				item = null;
				moPreset = null;
			}

			if ( !item ) return;

			_displayList.addItem( item );
			_presetsList.removeItem( item.clone() );
			updateReadyState();
		}

		/**
		 * После удачного сохранения пресета, запрашиваем с сервера обновлёный список пресетов
		 * @param event
		 */
		private function onPresetSaveComplete( event:PresetSaveEvent ):void
		{
			App.presetsService.getList();
		}

		/**
		 * Полученный с сервера список пресетов, обрабатываем и отображаем
		 * @param event
		 */
		private function onPresetsListComplete( event:PresetsListEvent ):void
		{
			_presetsList.clear();

			var listPresets:Vector.<MoPreset> = event.listPresets;

			for ( var i:uint = 0; i < listPresets.length; i++ ) {
				var itemPreset:MoPreset = listPresets[i];

				var itemList:ItemOfList = new ItemOfList( itemPreset.title, itemPreset.title, itemPreset );
				itemList.homeName = _presetsList.rootItem.keyName;
				itemList.viewed = true;
				_presetsList.addItem( itemList );

//				Log.traceText( itemList + " : " + itemPreset.title + ", " + itemPreset.listIDs );
			}

			_presetsView.setupList( _presetsList );
		}

		/***************************************************************************
		 Формирование списка РАЗДЕЛОВ
		 ***************************************************************************/
		private function sendPartsRequest():void
		{
			if ( !_vectItems ) {
				App.httpManager.addRequest( new ReqPartitions(), parsePartitions ); // Запрашиваем разделы
			} else {
				setupList();
			}
		}

		private function parsePartitions( req:ReqPartitions ):void
		{
			_vectItems = new Vector.<ItemOfList>();

			var vectParts:Vector.<MoListPartition> = ParserPartitions.serializeJSON( req.responseData );

			var part:MoListPartition;
			var item:ItemOfList;
			var len:uint = vectParts.length;

			for ( var i:int = 0; i < len; i++ ) {
				part = vectParts[ i ];

				if ( part.count > 0 ) { // Добавляем разделы, которые содержат сущности
					item = new ItemOfList( part.name + " (" + part.count + ")", part.name, part );
					item.homeName = _originList.rootItem.keyName;
					item.viewed = true;
					_vectItems.push( item );

					_originList.addItem( item );

//					Log.traceText( item + " : " + part.count );
				}
			}

			procSendEntitiesRequest();
		}

		/***************************************************************************
		 Формирование и отображение списка СУЩНОСТЕЙ
		 ***************************************************************************/
		//{ region Получение с сервера списка сущностей из заданного раздела и парсинг
		private var _idxPart:int = -1;

		private function procSendEntitiesRequest():void
		{
			_idxPart++;

			if ( _idxPart >= _vectItems.length ) {
				setupList();
				return;
			}

			var curItemPart:ItemOfList = _vectItems[ _idxPart ];

			if ( !curItemPart.countChildren ) {
				App.httpManager.addRequest(
						new ReqPartEntities( ( curItemPart.dataObject as MoListPartition ).type ),
						parseEntities
				);
			} else {
				procSendEntitiesRequest();
			}
		}

		// Парсим полученный список сущностей
		private function parseEntities( req:ReqPartEntities ):void
		{
			var vectEnts:Vector.<MoListEntity> = ParserEntities.serializeJSON( req.responseData );

			var curItemPart:ItemOfList = _vectItems[ _idxPart ];
			var ent:MoListEntity;
			var itemEnt:ItemOfList;
			var len:uint = vectEnts.length;
			var numCounter:uint = 1;

			for ( var i:int = 0; i < len; i++ ) {
				ent = vectEnts[ i ];

				if ( ent.count > 0 ) { // Добавляем сущности, которые содержат события
					itemEnt = new ItemOfList( numCounter + ". " + ent.name + " ~" + ent.count, ent.name, ent );
					itemEnt.homeName = _originList.rootItem.keyName;
					curItemPart.pushChild( itemEnt );

					numCounter++;
				}
			}

			procSendEntitiesRequest();
		}

		//} endregion

		private function onClickOriginal( ev:MouseEvent ):void
		{
			var itemView:ViewItemList = ev.target as ViewItemList;

			if ( !itemView ) return;

			var item:ItemOfList = ( itemView.customData as ItemOfList ).clone();

			_displayList.addItem( item );
			_originList.removeItem( item.clone() );

			updateReadyState();
		}

		private function onClickTarget( ev:MouseEvent ):void
		{
			var itemView:ViewItemList = ev.target as ViewItemList;

			if ( !itemView ) {
				return;
			}

			var item:ItemOfList = ( itemView.customData as ItemOfList ).clone();

			// BUG: Если во второй список перекинуть один дочерний элемент, потом свернуть родителя и затем перенести его в свётнутом виде,
			// то повторив перенос, состояние кнопки элемента будет закрытое (кнопка будет как-будто свёрнута).

			if ( item.homeName == _presetsList.rootItem.keyName ) {
				_presetsList.addItem( item );
			} else {
				_originList.addItem( item );
			}

			_displayList.removeItem( item.clone() );

			updateReadyState();
		}

		private function onClickPreset( event:MouseEvent ):void
		{
			var itemView:ViewItemList = event.target as ViewItemList;

			if ( !itemView ) return;

			var item:ItemOfList = ( itemView.customData as ItemOfList ).clone();

			_displayList.addItem( item );
			_presetsList.removeItem( item.clone() );

			updateReadyState();
		}

		private function setupList():void
		{
			// Удаляем из списка пустые разделы (которые не содержат сущностей)
			var rootChildren:Dictionary /*ItemOfList*/ = _originList.rootChildren;
			for each ( var child:ItemOfList in rootChildren ) {
				if ( child.countChildren == 0 ) {
					_originList.removeItem( child );
				}
			}

			_originView.setupList( _originList );
			_targetView.setupList( _displayList );
			_presetsView.setupList( _presetsList );

			updateReadyState();
		}

		private function updateReadyState():void
		{
			if ( _displayList.rootItem.countChildren ) {
				if ( !contains( _btnReady ) ) {
					addChild( _btnReady );
				}
			} else {
				if ( contains( _btnReady ) ) {
					removeChild( _btnReady );
				}
			}
		}

		private function onReleaseReady():void
		{
			var arr:Array = _displayList.getFlatArrayData();

			var listIDs:Vector.<String> = new Vector.<String>();

			for ( var i:int = 0; i < arr.length; i++ ) {
				var item:* = arr[i];
				if ( item is MoPreset ) {
					var presetItem:MoPreset = item as MoPreset;
					listIDs = listIDs.concat( Vector.<String>( presetItem.listIDs ) );
				} else {
					listIDs.push( item.id );
				}
			}

			EntitiesDataWebService.downloadDataEntities( listIDs );
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width( value:Number ):void
		{
			_width = value;

			updateSize();
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height( value:Number ):void
		{
			_height = value;

			updateSize();
		}

		private function updateSize():void
		{
			_btnReady.x = int( ( width - _btnReady.width ) / 2 );
			_btnReady.y = height - _btnReady.height - 10;

			var ww:uint = Math.round( _width / 2 ) - 40;
			var hh:uint = _btnReady.y - _tfOrigin.height - 20;

			_originView.width = _presetsView.width = _targetView.width = ww;
			_targetView.x = _originView.width + 30;

			_originView.height = hh / 2 - 5;
			_presetsView.height = hh / 2 - _tfPresets.height - 5;
			_targetView.height = hh;
			_originView.y = _targetView.y = _tfOrigin.height + 5;
			_presetsView.y = _originView.y + _originView.height + _tfPresets.height + 10;

			_tfTarget.x = _targetView.x;
			_tfPresets.x = _presetsView.x;
			_tfPresets.y = _originView.y + _originView.height + 5;
		}


		override public function kill():void
		{
			App.presetsService.eventManager.removeEventListener( PresetsListEvent.COMPLETE, onPresetsListComplete );
			App.presetsService.eventManager.removeEventListener( PresetSaveEvent.COMPLETE, onPresetSaveComplete );

			super.kill();
		}
	}

}
