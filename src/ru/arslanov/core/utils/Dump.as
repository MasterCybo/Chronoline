package ru.arslanov.core.utils {
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Dump {
		
		static public function object( obj:Object ):String {
			return parse( obj, 0 );
		}
		
		static public function array( arr:* ):String {
			return parse( arr, 0 );
		}
		
		static public function displayObject( object:Object ):String {
			return parseDisplayObject( object, 0 );
		}
		
		static private function parseDisplayObject( object:Object, level:int ):String {
			var str:String = getIndent( level ) + object.toString() + "\n";
			if ( !( "numChildren" in object ) ) return str;
			
			var len:uint = object["numChildren"];
			var obj:Object;
			
			for (var i:int = 0; i < len; i++) {
				obj = object.getChildAt( i );
				
				if ( obj ) {
					str += getIndent( level + 1 ) + obj + " - x: " + obj.x + ", y: " + obj.y + "\n";
					
					if ( "numChildren" in obj ) {
						if ( obj["numChildren"] ) {
							str += parseDisplayObject( obj, level + 1 );
						}
					}
				}
			}
			
			return str;
		}
		
		static private function parse( obj:*, level:int ):String {
			var str:String = "";
			var indent:String = getIndent( level );
			var className:String = getClassName( obj );
			
			if ( obj == null ) return "null";
			if ( obj is Number ) return "" + obj;
			if ( obj is Boolean ) return "" + obj;
			if ( obj is String ) return "" + obj;
			if ( obj is Array ) return parseArray( obj, level );
			if ( className && className.toLowerCase().indexOf( "vector" ) != -1 ) return parseArray( obj, level );
			
			if ( "addChild" in obj ) {
				return "[" + className + " " + obj.name + "]:{ x:" + obj.x + ", y:" + obj.y + ", WxH:" + obj.width + "x" + obj.height + ", alpha:" + obj.alpha + ", visible:" + obj.visible + " };";
			}
			
			if ( obj is Object ) {
				var objName:String = "name" in obj ? "[" + obj.name + "]" : "";
				
				str += className + objName + ":{\n";
				
				var xmlDef:XML = describeType( obj );
				
				if ( xmlDef.children().length() > 0 ) {
					var props:XMLList = xmlDef..variable.@name;
					
					props += xmlDef..accessor.@name;
					props += xmlDef..constant.@name;
					
					for each ( var prop:String in props ) {
						if ( level > 10 ) break;
						
						var value:String;
						if ( prop.indexOf( "color" ) != -1 ) {
							value = "0x" + Number( obj[ prop ] ).toString( 16 );
						} else if ( prop in obj ) {
							value = parse( obj[ prop ], level + 1 );
						}
						
						str += indent + prop + ": " + value + ",\n";
					}
				} else {
					for ( var name:String in obj ) {
						str += indent + name + ": " + parse( obj[ name ], level + 1 ) + ",\n";
					}
					
					str = str.substring( 0, str.length - 2 ) + "\n";
				}
				
				str += getIndent( level - 1 ) + "}";
			}
			
			return str;
		}
		
		static private function parseArray( arr:*, level:int ):String {
			var str:String = "";
			var indent:String = getIndent( level );
			var len:Number = arr.length;
			
			str += getClassName( arr ) + "(" + len + "):[\n";
			
			for (var i:int = 0; i < len; i++) {
				str += indent + i + ": " + parse( arr[i], level + 1 ) + ",\n";
			}
			
			str = str.substring( 0, str.length - 2 ) + "\n" + getIndent( level - 1 ) + "]";
			
			return str;
		}
		
		static private function getIndent( depth:int ):String {
			var ind:String = "";
			//depth++;
			while (depth--) ind += "\t";
			return ind;
		}
		
		static public function getClassName( obj:Object ):String {
			var className:String = String( getQualifiedClassName( obj ).split( "::" )[ 1 ] ).split( "." )[ 0 ];
			//trace( "getQualifiedClassName( obj ) : " + getQualifiedClassName( obj ) );
			//var className:String = getQualifiedClassName( obj ).split( "::" )[ 1 ];
			if ( obj is Array ) className = "Array";
			return className ? className : "object";
		}
	}

}