package data {
	import flash.utils.getQualifiedClassName;

	import ru.arslanov.core.utils.Calc;
	import ru.arslanov.core.utils.Log;

	/**
	 * Событие, веха сущности Fact
	 * @author Artem Arslanov
	 */
	public class MoFact extends ModelBase {
		
		public var period:MoPeriod;
		public var rank:uint = 0;
		public var categories:Vector.<MoPicture> = new Vector.<MoPicture>();
		public var urlMore:String = "";
		
		public function MoFact( id:String, title:String, period:MoPeriod, rank:uint = 0 ) {
			this.period = period;
			this.rank = rank;

			super( id, title );
		}
		
		public function get duration():Number {
			return period.duration;
		}
		
		override public function toString():String {
			//return "[" + getQualifiedClassName( this ) + " " + uidStr + ", " + id + ", title=" + title.substr( 0, 15 ) + "... " + period.dateBegin.getValue() + " - " + period.dateEnd.getValue() + "]";
			return "[" + getQualifiedClassName( this ) + " " + id + ", "+ period + "]";
		}
		
		/**
		 * Статический метод создания модели из JSON-данных
		 * @param	json
		 * @return
		 */
		static public function fromJSON( id:String, json:Object ):MoFact {
			var newPeriod:MoPeriod = new MoPeriod( Number( json.bjd ), Number( json.ejd ) );
			
			// Тестовое увеличение продолжительности события
			//newPeriod.dateEnd.setValue( newPeriod.dateEnd.getValue() + uint( Math.random() * 5 ) );

//			var moFact:MoFact = new MoFact( id, json.title, newPeriod ); // test
			var moFact:MoFact = new MoFact( id, json.title, newPeriod, json.rank );
			moFact.urlMore = json.link ? json.link : "";

			// Тестовый случайный масштаб иконки для теста
//			moFact.rank = Calc.randomRange( 30, 100, true );
			
			var arrCategory:Array = json.category;

			var name:String;
			for ( name in arrCategory ) {
				moFact.categories.push( MoPicture.fromJSON( arrCategory[ name ] ) );
			}
			
			return moFact;
		}
	}

}
