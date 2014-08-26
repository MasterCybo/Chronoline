package services {
	import collections.BondsManager;
	import collections.EntityManager;

	import constants.LocaleString;

	import data.MoBond;
	import data.MoEntity;
	import data.MoFact;

	import events.ProcessFinishNotice;
	import events.ProcessStartNotice;
	import events.ServerDataCompleteNotice;
	import events.SysMessageDisplayNotice;

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
		
		static public const OBJECTS_PER_REQUEST:uint = 1000;
		
		static private var _downloadEntities:Vector.<String>;
		static private var _downloadBonds:Vector.<String>;
		static private var _offsetIdx:uint;

		
		static public function downloadDataEntities( listIDs:Vector.<String> ):void {
			_offsetIdx = 0;
			
			BondsManager.clear();
			
			_downloadEntities = EntityManager.refineMissingEntities( listIDs );
			_downloadBonds = _downloadEntities.concat();

			// Если список запрашиваемых ID пуст, то заканчиваем приём данных
			if ( !_downloadEntities.length ) {
				completeDataEntities();
			} else {
				Notification.send( ProcessStartNotice.NAME );
				requestDataEntities();
			}
		}
		
		/***************************************************************************
		Обработка СУЩНОСТЕЙ
		***************************************************************************/
		static private function requestDataEntities():void {
			App.httpManager.addRequest( new ReqEntityData( _downloadEntities, _offsetIdx, OBJECTS_PER_REQUEST ), parseDataEntities, onError );
		}
		
		static private function onError():void {
			Notification.send( SysMessageDisplayNotice.NAME, new SysMessageDisplayNotice( LocaleString.SERVER_ERROR_RESPONSE ) );
		}
		
		static private function parseDataEntities( req:ReqEntityData ):void {
			var json:Object = JSON.parse( String( req.responseData ) );
			
			//Log.traceText( "data : " + data );
			
			if ( json == null ) {
				Log.traceError( "Not correct incoming responseData. JSON format error: " + req.responseData );
				return;
			}

			// Парсим сущности
			var countFacts:uint = 0;
			var name:String;
			for ( name in json ) {
				Log.traceText( "Parse Entity data ID = " + name );
				countFacts += parseEntity( json[ name ] );
//				countFacts++;
			}
			
			// Если количество обработанных данных
			if ( countFacts < OBJECTS_PER_REQUEST ) {
				// ... меньше величины шага - переходим к связям
				EntityManager.updateBounds();

				_offsetIdx = 0;
				requestDataBonds();
			} else {
				// ... равно величине шага - делаем ещё запрос
				_offsetIdx += OBJECTS_PER_REQUEST; // Увеличиваем смещение
				requestDataEntities();
			}
		}
		
		static private function parseEntity( entityData:Object ):uint {
			var numFacts:uint = 0;

			var entNew:MoEntity = MoEntity.fromJSON( entityData );

			if ( (entNew.id == null) || (entNew.title == null) ) {
				Log.traceError( "Invalid Entity data : " + JSON.stringify(entityData) );
				return 0;
			}

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

			return numFacts;
		}
		//} endregion

		/***************************************************************************
		Обработка СВЯЗЕЙ
		***************************************************************************/
		static private function requestDataBonds():void {
			App.httpManager.addRequest( new ReqBindingsData( _downloadBonds, _offsetIdx, OBJECTS_PER_REQUEST ), parseDataBonds, onError );
		}
		
		static private function parseDataBonds( req:ReqBindingsData ):void {
			//Log.traceText( "*execute* EntitiesDataWebService.parseDataBonds" );
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
			
			Log.traceText( "Bonds added : " + numAdded );
			
			//Notification.send( ProcessUpdateNotice.NAME, new ProcessUpdateNotice( 1 - _listEntityData.length / _total, 1 ) );
			
			if ( numAdded < OBJECTS_PER_REQUEST ) {
				// Все данные от сервера получили - отправляем событие
				Notification.send( ProcessFinishNotice.NAME );
				completeDataEntities();
			} else {
				_offsetIdx += OBJECTS_PER_REQUEST;// Увеличиваем смещение
				requestDataBonds();
			}
		}

		static private function completeDataEntities():void {
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
