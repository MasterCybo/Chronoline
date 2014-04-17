package data {
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.core.utils.Log;
	/**
	 * Историческая сущность
	 * @author Artem Arslanov
	 */
	public class MoEntity extends ModelBase {
		
		// События, связанные с этой сущностью
		private var _mapMoFacts:Dictionary/*MoFact*/ = new Dictionary( true ); // MoFact.id = MoFact
		//private var _listMoFacts:Array/*MoFact*/ = [];
		private var _listMoFacts:Vector.<MoFact> = new Vector.<MoFact>();
		private var _firstMoFact:MoFact;
		private var _lastMoFact:MoFact;
		private var _duration:Number = 0;
		
		public function MoEntity( id:String, title:String ) {
			super( id, title );
		}
		
		public function addFact( moFact:MoFact ):void {
			if ( getMoFact( moFact.id ) ) {
				Log.traceWarn( "MoEntity.addFact( " + moFact.id + " ) already exists!" );
				return;
			}
			
			_mapMoFacts[moFact.id] = moFact;
			_listMoFacts.push( moFact );
			
			if ( !_firstMoFact ) {
				_firstMoFact = moFact;
			} else {
				if ( moFact.period.beginJD < _firstMoFact.period.beginJD ) {
					_firstMoFact = moFact;
				}
			}
			
			if ( !_lastMoFact ) {
				_lastMoFact = moFact;
			} else {
				if ( moFact.period.endJD > _lastMoFact.period.endJD ) {
					_lastMoFact = moFact;
				}
			}
			
			_duration = _lastMoFact.period.endJD - _firstMoFact.period.beginJD;
		}
		
		public function sortFacts():void {
			_listMoFacts.sort( compareByDateBegin );
		}
		
		private function compareByDateBegin( fact1:MoFact, fact2:MoFact ):Number {
			if ( fact1.period.beginJD > fact2.period.beginJD ) return 1;
			if ( fact1.period.beginJD < fact2.period.beginJD ) return -1;
			return 0;
		}
		
		public function getMoFact( id:String ):MoFact {
			return _mapMoFacts[id];
		}
		
		//public function get facts():Array/*MoFact*/ {
		public function get facts():Vector.<MoFact> {
			return _listMoFacts;
		}
		
		public function get beginPeriod():MoPeriod {
			return _firstMoFact ? _firstMoFact.period : null;
		}
		
		public function get endPeriod():MoPeriod {
			return _lastMoFact ? _lastMoFact.period : null;
		}
		
		public function get duration():Number {
			//return dateBegin && dateEnd ? dateEnd.end.getValue() - dateBegin.begin.getValue() : 0;
			return _duration;
		}
		
		override public function toString():String {
			return "[" + getQualifiedClassName( this ) + " " + uidStr + ", id=" + id + ", title=" + title.substr( 0, 15 ) + "... " + beginPeriod + " - " + endPeriod + " = " + duration + ", facts=" + facts.length + "]";
		}
		
		public function dispose():void {
			_mapMoFacts = null;
			_listMoFacts = null;
			_firstMoFact = null;
			_lastMoFact = null;
		}
		
		/**
		 * Статический метод создания модели из JSON-данных
		 * @param	json
		 * @return
		 */
		static public function fromJSON( json:Object ):MoEntity {
			var ent:MoEntity = new MoEntity( json.id, json.title );
			
			var facts:Object = json["milestones"];
			
			var num:uint;
			for ( var name:String in facts ) {
				num++;
				ent.addFact( MoFact.fromJSON( name, facts[name] ) );
			}
			
			Log.traceText( "\tAdded " + num + " facts." );
			
			return ent;
		}
	}

}
