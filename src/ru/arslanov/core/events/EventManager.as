package ru.arslanov.core.events {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;

	/**
	 * Менеджер подписчиков
	 * @author Artem Arslanov
	 */
	public class EventManager {
		
		static private var _tracer:Function = trace;
		
		static public function tracer( traceMethod:Function ):void {
			_tracer = traceMethod;
		}
		
		
		private var _target:IEventDispatcher;
		private var _listeners:Dictionary/*Vector.<EventData>*/; // Формат type:Vector.<EventData>
		
		public function EventManager( target:IEventDispatcher = null ) {
			_target = target ? target : new EventDispatcher();
			_listeners = new Dictionary( true );
		}
		
		public function get target():IEventDispatcher {
			return _target;
		}
		
		/***************************************************************************
		Подписка на событие
		***************************************************************************/
		public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			// Проверяем, существуют ли записи для этого события, если нет, тогда создаём пустую запись
			var vect:Vector.<EventData> = _listeners[ type ];
			if ( vect == null ) {
				vect = new Vector.<EventData>();
				_listeners[ type ] = vect;
			}
			
			// Проверяем, зарегистрировано ли это событие
			var item:EventData;
			for each ( item in vect ) {
				if ( item.equalsParams( type, listener, useCapture ) ) {
					Log.traceWarn( 'EventManager.addEvent : The event listener "' + type + '" for ' + _target + ' already exists.' );
					return;
				}
			}
			
			vect.push( new EventData( type, listener, useCapture ) );
			_target.addEventListener( type, listener, useCapture, priority, useWeakReference );
			
			traceMessage( _target + ".addEventListener : " + type );
		}
		
		/***************************************************************************
		Проверка подписки события
		***************************************************************************/
		public function hasEvent( type:String, listener:Function = null, useCapture:Boolean = false ):Boolean {
			if ( type && listener && useCapture ) {
				var vect:Vector.<EventData> = _listeners[ type ];
				if ( !vect ) return false;
				
				var item:EventData;
				for each ( item in vect ) {
					if ( item.equalsParams( type, listener, useCapture ) ) {
						return true;
					}
				}
			}
			
			return _listeners[ type ] && _listeners[ type ].length;
		}
		
		/***************************************************************************
		Отписка от события
		***************************************************************************/
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void {
			// Проверяем, есть ли запись данного типа события
			var vect:Vector.<EventData> = _listeners[ type ];
			if ( !vect || ( vect.length == 0 ) ) {
				Log.traceWarn( 'EventManager.removeEvent (' + type + ') : Object ' + _target + ' not have listeners.' );
				return;
			}
			
			// Проверяем, если находим событие - удаляем
			var i:int = vect.length;
			while ( i-- ) {
				if ( vect[i].equalsParams( type, listener, useCapture ) ) {
					vect.splice( i, 1 );
					_target.removeEventListener( type, listener, useCapture );
					traceMessage( _target + ".removeEventListener : " + type );
					return;
				}
			}
			
			Log.traceWarn( 'EventManager.removeEvent : Object ' + _target + ' not found listeners on event "' + type + '".' );
		}
		
		/***************************************************************************
		Отписываемся от всех событий
		***************************************************************************/
		public function removeAllEventListeners():void {
			var vect:Vector.<EventData>;
			var item:EventData;
			for each ( vect in _listeners ) {
				for each ( item in vect ) {
					_target.removeEventListener( item.type, item.listener, item.useCapture );
				}
				vect.length = 0;
			}
		}
		
		public function dispatchEvent( event:Event ):Boolean {
			return _target.dispatchEvent( event );
		}
		
		static private function traceMessage( message:String ):void {
			if ( _tracer == null ) return;
			
			_tracer( message );
		}
		
		public function dispose():void {
			removeAllEventListeners();
			
			_listeners.length = 0;
			_listeners = null;
			_target = null;
		}
		
		
	}

}

internal class EventData {
	public var type:String;
	public var listener:Function;
	public var useCapture:Boolean;
	
	public function EventData( type:String, listener:Function, useCapture:Boolean ):void {
		this.type = type;
		this.listener = listener;
		this.useCapture = useCapture;
	}
	
	public function equals( evData:EventData ):Boolean {
		return equalsParams( evData.type, evData.listener, evData.useCapture );
	}
	
	public function equalsParams( type:String, listener:Function, useCapture:Boolean ):Boolean {
		return ( this.type == type ) && ( this.listener == listener ) && ( this.useCapture == useCapture );
	}
}