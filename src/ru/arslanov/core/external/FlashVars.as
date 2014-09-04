package ru.arslanov.core.external {
	import flash.display.LoaderInfo;
	import flash.display.Stage;

	import ru.arslanov.core.utils.Log;

	/**
	 * Статический класс для комфортной работы с Flash Vars
	 * @author Artem Arslanov
	 */
	public class FlashVars {
		
		static private var _fvars:Object = {};
		
		public function FlashVars() {
			
		}
		
		static public function init( stage:Stage ):void {
			_fvars = LoaderInfo( stage.loaderInfo ).parameters;
		}
		
		static public function getValue( name:String, defaultValue:* = null ):* {
			return _fvars[name] ? _fvars[name] : defaultValue;
		}
		
		static public function getNumber( name:String, defaultValue:Number = 0 ):Number {
			return _fvars[name] ? Number( _fvars[name] ) : defaultValue;
		}
		
		static public function getString( name:String, defaultValue:String = "" ):String {
			return _fvars[name] ? String( _fvars[name] ) : defaultValue;
		}
		
		static public function getBoolean( name:String, defaultValue:Boolean = false ):Boolean {
			return _fvars[name] ? String( _fvars[name] ) == "true" : defaultValue;
		}
		
		static public function dump():void {
			Log.traceText( "FlashVars:" );
			Log.traceObject( _fvars );
		}
	}

}