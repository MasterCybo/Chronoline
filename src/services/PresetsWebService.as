/**
 * Created by aa on 16.05.2014.
 */
package services
{
	import data.MoPreset;

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
		private var _list:Vector.<MoPreset> = new Vector.<MoPreset>();
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

			_list.length = 0;

			for ( var i:int = 0; i < listObjects.length; i++ ) {
				_list.push( MoPreset.parse( listObjects[i] ) );
			}
			
			eventManager.dispatchEvent( new PresetsListEvent( _list.concat() ) );
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

		public function get list():Vector.<MoPreset>
		{
			return _list;
		}

		public function set list( value:Vector.<MoPreset> ):void
		{
			_list = value;
		}

		public function getPreset( id:String ):MoPreset
		{
			var preset:MoPreset;

			for each ( preset in list ) {
				if ( preset.id == id ) {
					return preset;
				}
			}
			
			return null;
		}

		public function clearList():void
		{
			_list.length = 0;
		}
		
		public function dispose():void
		{
			_httpManager = null;
			_eventManager.dispose();
		}
	}
}
