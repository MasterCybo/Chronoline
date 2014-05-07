package collections {
	import com.adobe.utils.DictionaryUtil;

	import data.MoBond;

	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BondsManager {
		
		static private var _bonds:Dictionary/*Vector.<MoBond>*/ = new Dictionary( true ); // MoFact.id = Vector.<MoBond>
		
		public function BondsManager() {
			
		}
		
		static public function addItem( moBond:MoBond ):void {
			// id связи = id события сущности
			if ( _bonds[moBond.id] == undefined ) {
				_bonds[moBond.id] = new Vector.<MoBond>();
			}
			
			_bonds[moBond.id].push( moBond );
		}
		
		static public function getItems( factID:String ):Vector.<MoBond> {
			return _bonds[factID];
		}
		
		static public function getArrayBonds():Array {
			//for (var name:String in _entities) {
				//Log.traceText( name + " : " + _entities[name] );
			//}
			
			var arr:Array = DictionaryUtil.getValues( _bonds );
			
			//arr.sortOn( ["id"], [Array.NUMERIC] );
			//arr.sortOn( "id", Array.NUMERIC );
			//arr.sortOn( "id" );
			
			return arr;
		}
		
		static public function removeItems( id:String ):void {
			delete _bonds[id];
		}
		
		static public function getListMoFactsIDs():Array/*MoBond*/ {
			var arr:Array = [];
			var name:String;
			
			for ( name in _bonds ) {
				arr.push( name );
			}
			
			return arr;
		}
		
		static public function parseJSON( json:Object ):void {
			var num:uint;
			for ( var name:String in json ) {
				num++;
				addItem( MoBond.fromJSON( json[name] ) );
			}
			
			Log.traceText( "Bonds " + num + " added." );
		}
		
		static public function clear():void {
			_bonds = new Dictionary( true );
		}
	}

}