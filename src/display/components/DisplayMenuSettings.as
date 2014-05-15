package display.components
{
	import collections.tree.ItemOfList;
	import collections.tree.TreeList;

	import constants.LocaleString;
	import constants.TextFormats;

	import controllers.EntitiesDataFactory;
	import controllers.ParserEntities;
	import controllers.ParserPartitions;

	import data.MoListEntity;
	import data.MoListPartition;
	import data.MoPresetItemList;

	import display.base.TextApp;
	import display.gui.buttons.ButtonText;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	import net.ReqPartEntities;
	import net.ReqPartitions;
	import net.ReqPresetsList;

	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;

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
		private var _targetList:TreeList;
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
			_originList = new TreeList( "originTree" );
			_targetList = new TreeList( "targetTree" );
			_presetsList = new TreeList( "presetsList" );

			// Заголовки списков
			_tfOrigin = new TextApp( LocaleString.TITLE_ORIGIN, TextFormats.LIST_HEADER ).init();
			_tfTarget = new TextApp( LocaleString.TITLE_TARGET, TextFormats.LIST_HEADER ).init();
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

			sendPartsRequest();

			return super.init();
		}

		/***************************************************************************
		 Формирование списка РАЗДЕЛОВ
		 ***************************************************************************/
		private function sendPartsRequest():void
		{
			if ( !_vectItems ) {
				App.httpManager.addRequest( new ReqPresetsList(), parsePresets ); // Запрашиваем пресеты
				App.httpManager.addRequest( new ReqPartitions(), parsePartitions ); // Запрашиваем разделы
			} else {
				setupList();
			}
		}

		private function parsePresets( req:ReqPresetsList ):void
		{
			Log.traceText( "ReqPresetsList.responseData : " + req.responseData );

			var listObjects:Array = JSON.parse( String( req.responseData ) ) as Array;
			var listPresets:Vector.<MoPresetItemList> = new Vector.<MoPresetItemList>();

			var i:int;

			for ( i = 0; i < listObjects.length; i++ ) {
				var object:Object = listObjects[i];
				listPresets.push( MoPresetItemList.parse( object ) );
			}

//			Log.traceText( "listPresets : " + listPresets );

			for ( i = 0; i < listPresets.length; i++ ) {
				var itemPreset:MoPresetItemList = listPresets[i];

				var itemList:ItemOfList = new ItemOfList( itemPreset.title, itemPreset.title, itemPreset );
//				itemList.homeName = "presetsList";
				itemList.homeName = _presetsList.rootItem.keyName;
				itemList.viewed = true;
				_presetsList.addItem( itemList );
//				_targetList.addItem( itemList );

				Log.traceText( itemList + " : " + itemPreset.title + ", " + itemPreset.listIDs );
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
//					item.homeName = "originTree";
					item.homeName = _originList.rootItem.keyName;
					item.viewed = true;
					_vectItems.push( item );

					_originList.addItem( item );

					Log.traceText( item + " : " + part.count );
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
//					itemEnt.homeName = "originTree";
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
			var itemView:ItemTreeList = ev.target as ItemTreeList;

			if ( !itemView ) return;

			var item:ItemOfList = ( itemView.customData as ItemOfList ).clone();

			_targetList.addItem( item );
			_originList.removeItem( item.clone() );

			updateReadyState();
		}

		private function onClickTarget( ev:MouseEvent ):void
		{
			var itemView:ItemTreeList = ev.target as ItemTreeList;

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

			_targetList.removeItem( item.clone() );

			updateReadyState();
		}

		private function onClickPreset( event:MouseEvent ):void
		{
			var itemView:ItemTreeList = event.target as ItemTreeList;

			if ( !itemView ) return;

			var item:ItemOfList = ( itemView.customData as ItemOfList ).clone();

			_targetList.addItem( item );
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
			_targetView.setupList( _targetList );
			_presetsView.setupList( _presetsList );

			updateReadyState();
		}

		private function updateReadyState():void
		{
			if ( _targetList.rootItem.countChildren ) {
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
			//Notification.send( UpdateChronolineNotice.NAME, new UpdateChronolineNotice() );

			var arr:Array = _targetList.getFlatArrayData();

			Log.traceText( "arr : " + arr );

			var vect:Vector.<MoListEntity> = new Vector.<MoListEntity>();

			for ( var i:int = 0; i < arr.length; i++ ) {
				var item:* = arr[i];
				if ( item is MoPresetItemList ) {
					var presetItem:MoPresetItemList = item as MoPresetItemList;
					var listIDs:Array = presetItem.listIDs;
					for ( var j:int = 0; j < listIDs.length; j++ ) {
						var id:String = listIDs[j];
						var moListEnt:MoListEntity = new MoListEntity(id, "", 1 );
						vect.push( moListEnt );
					}
				} else {
					vect.push( item );
				}
			}

//			var vect:Vector.<MoListEntity> = Vector.<MoListEntity>( _targetList.getFlatArrayData() );

			//Log.traceText( "vect : " + vect );

			EntitiesDataFactory.start( vect );
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
	}

}
