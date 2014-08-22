package collections {
	import com.adobe.utils.DictionaryUtil;

	import data.MoBond;
	import data.MoBondsGroup;

	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BondsManager {
		
		static private var _bondGroups:Dictionary/*MoBondsGroup*/ = new Dictionary( true ); // MoFact.id = MoBondsGroup
		
		public function BondsManager() {
			
		}
		
		static public function addItem( moBond:MoBond ):void {
			// id связи = id события сущности

			var group:MoBondsGroup = _bondGroups[moBond.id];

			if ( !group ) {
				group = new MoBondsGroup( moBond.id, moBond.entityUid1, moBond.entityUid2 );

				_bondGroups[group.id] = group;
			}

			group.listBonds.push( moBond );
		}
		
		static public function getBonds( factID:String ):MoBondsGroup {
			return _bondGroups[factID];
		}

		static public function clear():void {
			_bondGroups = new Dictionary( true );
		}
	}

}