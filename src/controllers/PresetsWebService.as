/**
 * Created by aa on 16.05.2014.
 */
package controllers
{
	import data.MoPresetItemList;

	import events.PresetSaveEvent;
	import events.PresetsListEvent;

	import flash.events.EventDispatcher;

	import net.ReqPresetSave;
	import net.ReqPresetsList;

	import ru.arslanov.core.events.EventManager;
	import ru.arslanov.core.http.HTTPManager;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class PresetsWebService extends EventDispatcher
	{

		private var _eventManager:EventManager;
		private var _httpManager:HTTPManager;

		public function PresetsWebService( httpManager:HTTPManager )
		{
			_httpManager = httpManager;
			_eventManager = new EventManager( this );
		}

		/**
		 * Запрос с сервера списка пресетов
		 */
		public function getList():void
		{
			_httpManager.addRequest( new ReqPresetsList(), parseListPresets ); // Запрашиваем пресеты
		}

		private function parseListPresets( req:ReqPresetsList ):void
		{
			var listObjects:Array = JSON.parse( String( req.responseData ) ) as Array;

			var event:PresetsListEvent = new PresetsListEvent( new Vector.<MoPresetItemList>() );

			for ( var i:int = 0; i < listObjects.length; i++ ) {
				event.listPresets.push( MoPresetItemList.parse( listObjects[i] ) );
			}

			eventManager.dispatchEvent( event );
		}

		/**
		 * Сохранение на сервере набора сущностей
		 * @param namePreset
		 * @param listIDs
		 */
		public function save( namePreset:String, listIDs:Array ):void
		{
			_httpManager.addRequest( new ReqPresetSave( listIDs, namePreset ), onSaveResponse );
		}

		private function onSaveResponse( req:ReqPresetSave ):void
		{
			eventManager.dispatchEvent( new PresetSaveEvent( String( req.responseData ) ) );
		}

		public function get eventManager():EventManager
		{
			return _eventManager;
		}

		public function dispose():void
		{
			_httpManager = null;
			_eventManager.dispose();
		}
	}
}
