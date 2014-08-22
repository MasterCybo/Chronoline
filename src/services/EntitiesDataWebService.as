package services {
	import collections.BondsManager;
	import collections.EntityManager;

	import constants.LocaleString;

	import data.MoBond;
	import data.MoEntity;
	import data.MoFact;
	import data.MoListEntity;

	import events.ProcessFinishNotice;
	import events.ProcessStartNotice;
	import events.ProcessUpdateNotice;
	import events.ServerDataCompleteNotice;
	import events.SysMessageDisplayNotice;

	import flash.utils.Dictionary;

	import net.ReqBindingsData;
	import net.ReqEntityData;

	import ru.arslanov.core.events.Notification;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.core.utils.StringUtils;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class EntitiesDataWebService {
		
		static public const DEF_LENGTH:uint = 1000;
		
		static private var _entityIDs:Array;
		static private var _bindingEntityIDs:Array;
		static private var _listIDs:Vector.<String>;
		static private var _offsetIdx:uint;
		static private var _total:uint;
		static private var _progress:uint;

		
		static public function start( entitiesID:Vector.<String> ):void {
			_listIDs = entitiesID;
			_entityIDs = [];
			_bindingEntityIDs = [];
			
			_total = 0;
			_progress = 0;
			_offsetIdx = 0;
			
			BondsManager.clear();
			
			//Log.traceText( "_listEntityData : " + _listEntityData );
			
			// Вычёркиваем из списка, сущности, которые уже загружены
			var entID:String;
			var moEnt:MoEntity;
			for each ( entID in _listIDs ) {
				moEnt = EntityManager.getItem( entID );
				
				if ( !moEnt ) {
					_entityIDs.push( entID );
					_total++;
				}
				
				// Создаём список запроса для связей
				_bindingEntityIDs.push( entID );
			}
			
			Log.traceText( "_listEntityData.length : " + _listIDs.length );
			Log.traceText( "_total : " + _total );

			// Удаляем из менеджера сущностей те, которые отсутствуют
			var mapMoEnts:Dictionary = EntityManager.mapMoEntities;
			var isRemove:Boolean;
			
			for each ( moEnt in mapMoEnts ) {
				isRemove = true;
				for each ( entID in _listIDs) {
					if ( entID == moEnt.id ) {
						isRemove = false;
						break;
					}
				}
				
				if ( isRemove ) {
					//Log.traceText( "--- Удаляем из словаря " + moEnt );
					EntityManager.removeItem( moEnt.id );
				}
			}
			
			//Log.traceText( "Enitites ID : " + _entityIDs );
			//Log.traceText( "Total milestones : " + _total );
			//Log.traceText( "_bindingEntityIDs : " + _bindingEntityIDs );
			
			// Если список запрашиваемых ID пуст, то заканчиваем приём данных
			if ( !_entityIDs.length ) {
				dataRequestComplete();
				return;
			}
			
			Notification.send( ProcessStartNotice.NAME );
			
			sendReqEntityData();
		}
		
		/***************************************************************************
		Обработка СУЩНОСТЕЙ
		***************************************************************************/
		//{ region
		static private function sendReqEntityData():void {
			//Log.traceText( "Запрашиваем данные : " + _entityIDs );
			//Log.traceText( "_offsetIdx : " + _offsetIdx );
			//Log.traceText( "DEF_LENGTH : " + DEF_LENGTH );
			
			App.httpManager.addRequest( new ReqEntityData( _entityIDs, _offsetIdx, DEF_LENGTH ), parseEntityData, onError );
		}
		
		static private function onError():void {
			Notification.send( SysMessageDisplayNotice.NAME, new SysMessageDisplayNotice( LocaleString.SERVER_ERROR_RESPONSE ) );
		}
		
		static private function parseEntityData( req:ReqEntityData ):void {
			var json:Object = JSON.parse( String( req.responseData ) );
			
			//Log.traceText( "data : " + data );
			
			if ( json == null ) {
				Log.traceError( "Not correct incoming responseData. JSON format error: " + req.responseData );
				return;
			}
			
			// Перебираем объекты данных

			var numData:uint = 0;
			var name:String;
			for ( name in json ) {
				Log.traceText( "Parse entity : " + name );
				numData += parseEntity( json[ name ] );
				numData++;
			}
			
//			Log.traceText( "numData : " + numData );
//			_progress ++;

			Log.traceText( "_progress : " + _progress );

//				Notification.send( ProcessUpdateNotice.NAME, new ProcessUpdateNotice( _progress / _total, 1 ) );

			// Если количество обработанных данных
			if ( numData < DEF_LENGTH ) {
				// ... меньше величины шага - переходим к связям
				EntityManager.updateBounds();

				_offsetIdx = 0;
				sendReqBindings();
			} else {
				// ... равно величине шага - делаем ещё запрос
				_progress ++;
				Notification.send( ProcessUpdateNotice.NAME, new ProcessUpdateNotice( _progress / _total, 1 ) );

				_offsetIdx += DEF_LENGTH; // Увеличиваем смещение
				sendReqEntityData();
			}
		}
		
		static private function parseEntity( entityData:Object ):uint {
			var numFacts:uint = 0;

			var entNew:MoEntity = MoEntity.fromJSON( entityData );
			var entExisting:MoEntity = EntityManager.getItem( entNew.id );
			
			if ( !entExisting ) {
				//Log.traceText( "Add new Entity : " + entNew );
				EntityManager.addItem( entNew );
				entNew.sortFacts();
				numFacts += entNew.facts.length;
			} else {
				//Log.traceText( "Already exists in : " + entExisting );
				var listMStones:Vector.<MoFact> = entNew.facts;
				var mstone:MoFact;
				for each (mstone in listMStones) {
					entExisting.addFact( mstone );
					numFacts++;
				}
				
				entExisting.sortFacts();
				
				entNew.dispose();
			}

			Log.traceText( "numFacts : " + numFacts );

			return numFacts;
		}
		//} endregion

		/***************************************************************************
		Обработка СВЯЗЕЙ
		***************************************************************************/
		//{ region
		static private function sendReqBindings():void {
			App.httpManager.addRequest( new ReqBindingsData( _bindingEntityIDs, _offsetIdx, DEF_LENGTH ), parseBonds );
		}
		
		static private function parseBonds( req:ReqBindingsData ):void {
			//Log.traceText( "*execute* EntitiesDataWebService.parseBonds" );
			var json:Object = JSON.parse( String( req.responseData ) );
			
			//Log.traceText( "data : " + data );
			
			if ( json == null ) {
				Log.traceError( "Not correct incoming responseData. JSON format error: " + req.responseData );
				return;
			}
			
			var numAdded:uint;
			var bondData:Object;
			var moBond:MoBond;
			var name:String;
			for (name in json) {
				bondData = json[name];
				
				moBond = MoBond.fromJSON( bondData );
				
				BondsManager.addItem( moBond );
				
				numAdded++;
			}
			
			Log.traceText( "Bindings added : " + numAdded );
			
			//Notification.send( ProcessUpdateNotice.NAME, new ProcessUpdateNotice( 1 - _listEntityData.length / _total, 1 ) );
			
			if ( numAdded < DEF_LENGTH ) {
				// Все данные от сервера получили - отправляем событие
				Notification.send( ProcessFinishNotice.NAME );
				dataRequestComplete();
				return;
			} else {
				_offsetIdx += DEF_LENGTH;// Увеличиваем смещение
				
				sendReqBindings();
			}
		}
		//} endregion
		
		static private function dataRequestComplete():void {
			Notification.send( ServerDataCompleteNotice.NAME );
		}
		
		static private function traceObject( obj:Object, level:uint = 0 ):void {
			var ind:String = StringUtils.repeat( "\t", level );
			
			for (var name:String in obj) {
				Log.traceText( ind + name + " : " + obj[name] );
				traceObject( obj[name], level + 1 );
			}
		}
	}
}
