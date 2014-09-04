package ru.arslanov.core.locale {
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import ru.arslanov.core.utils.Log;
	
	/**
	 * Localization, Dictionary
	 * @author Artem Arslanov
	 */
	public dynamic class Locale {
		
		static private const ID:String = "id";
		
		static public var language:String = "";
		static public var version:String = "";
		
		static private var _dict:Object = { };
		static private var _strings:Number = 0;
		static private var _rexp:RegExp = /\##(\w+)/g;
		
		public function Locale() {
			
		}
		
		static public function text( id:String ):String {
			var str:String = _dict[id];
			
			if ( ( str == null ) || ( str == "" ) ) return "%" + id; // if key not found, then return key
			
			var words:Array = str.match( _rexp );
			
			for each (var wrd:String in words ) {
				var uid:String = wrd.substring( 2 );
				str = str.replace( new RegExp( wrd, "g" ), _dict[uid] );
			}
			
			words = null;
			
			return str;
		}
		
		static public function loadFromClass( className:Class ):void {
			var descript:XML = describeType( className );
			
			var xmlList:XMLList = XMLList( descript["constant"] );
			
			var xml:XML;
			
			var len:Number = xmlList.length();
			for ( var i:uint = 0; i < len; i++ ) {
				if ( xmlList[i].@type == "XML" ) {
					//trace( "xmlList[i] : " + xmlList[i] );
					xml = XML( className[xmlList[i].@name] );
					break;
				} else if ( xmlList[i].@type == "Class" ) {
					//trace( "xmlList[i] : " + xmlList[i] );
					var ba:ByteArray = (new className[xmlList[i].@name]()) as ByteArray;
					var str:String = ba.readUTFBytes( ba.length );
					xml = XML( str );
					break;
				}
			}
			
			xml.ignoreWhite = true;
			
			parseXML( xml );
			
			Log.traceText( "Locale successful inited from class ( language: " + language + ", ver. " + version + ", strings: " + _strings + " )" );
		}
		
		static public function loadFromXML( xml:XML ):void {
			parseXML( xml );
			
			Log.traceText( "Locale successful inited from XML ( language: " + language + ", ver. " + version + ", strings: " + _strings + " )" );
		}
		
		static private function parseXML( xml:XML ):void {
			language = language ? language : xml.@language;
			version = version ? version : xml.@version;
			
			var nodes:XMLList = xml..children();
			//var nodes:XMLList = xml..text;
			
			for each (var item:XML in nodes) {
				//trace( item.@id + " = " + item + " - " + item.children().length() );
				if ( item.children().length() > 1 ) {
					parseXML( item );
				} else {
					_dict[item.@id] = normalize( item );
					_strings++;
				}
			}
			
			nodes = null;
		}
		
		static private function normalize( text:String ):String {
			return text.replace(/\\n/g, '\n');
		}
		
		static public function toString():String {
			var str:String = "";
			
			for ( var name:String in _dict ) {
				str += name + " = " + text(name) + "\n";
			}
			
			return str;
		}
	}

}