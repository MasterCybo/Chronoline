package ru.arslanov.core.http {
	import flash.net.URLVariables;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class HTTPRequest {
		
		static private var _counter:Number = 0;
		
		public var responseData:Object; // Данные, возвращаемые сервером
		
		public var ajax:Boolean = false;
		public var customDomain:String;
		public var method:String = "POST";
		public var url:String = "";
		public var vars:URLVariables = null;
		
		public var altURL:String = ""; // Альтернативный путь, если сервер не доступен, будет попытка загрузить 
		
		private var _uid:Number = 0;
		
		public function HTTPRequest( url:String, vars:URLVariables = null, ajax:Boolean = false, method:String = "POST" ) {
			_uid = ++_counter;
			
			this.ajax = ajax;
			this.url = url;
			this.vars = vars;
			this.method = method;
		}
		
		public function get uid():Number {
			return _uid;
		}
		
		public function get uidStr():String {
			return "0x" + uid.toString( 16 ).toUpperCase();
		}
		
		public function toString():String {
			return "[" + getQualifiedClassName( this ) + " " + uidStr + "]";
		}
	}

}