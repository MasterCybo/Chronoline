package data {
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.core.utils.Calc;
	
	/**
	 * Событие, веха сущности Fact
	 * @author Artem Arslanov
	 */
	public class MoFact extends ModelBase {
		
		public var period:MoPeriod;
		public var rank:uint = 100;
		public var categories:Vector.<MoPicture> = new Vector.<MoPicture>();
		
		public function MoFact( id:String, title:String, period:MoPeriod, rank:uint = 100 ) {
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
			
			// TODO: Удалить. Искусственное увеличение продолжительности события
			//newPeriod.dateEnd.setValue( newPeriod.dateEnd.getValue() + uint( Math.random() * 5 ) );
			
			//var moFact:MoFact = new MoFact( id, json.title, newPeriod, json.rank );
			var moFact:MoFact = new MoFact( id, json.title, newPeriod ); // test
			// TODO: Удалить. Cлучайный масштаб иконки для теста
			//moFact.rank = Calc.randomRange( 30, 100, true );
			
			var arrCategory:Array = json.category;
			
			var name:String;
			for ( name in arrCategory ) {
				// TODO: Удалить внутренний цикл. Для теста, количество иконок в категории задаётся случайно
				//var len:uint = Calc.randomRange( 0, 10, true );
				var len:uint = arrCategory.length;
				//Log.traceText( "len : " + len );
				for ( var i:int = 0; i < len; i++ ) {
					moFact.categories.push( MoPicture.fromJSON( arrCategory[ name ] ) );
				}
			}
			
			return moFact;
		}
	}

}
