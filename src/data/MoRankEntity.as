/**
 * Copyright (c) 2014 SmartHead. All rights reserved.
 */
package data
{
	import flash.utils.getQualifiedClassName;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MoRankEntity extends ModelBase
	{
		public var from:Number = 0;
		public var to:Number = 0;
		public var rank:Number = 0;

		public var fromPercent:Number = 0;
		public var toPercent:Number = 0;

		public var fromJD:Number = 0;
		public var toJD:Number = 0;

		public function MoRankEntity( from:Number = 0, to:Number = 0, rank:Number = 0 )
		{
			this.from = from;
			this.to = to;
			this.rank = rank;
		}

		override public function toString():String {
			return "[" + getQualifiedClassName( this )
					+ " "
					+ uidStr
					+ ", from=" + from
					+ ", to=" + to
					+ ", rank=" + rank
					+ "]";
		}

		/**
		 * Статический метод создания модели из JSON-данных
		 * @param	json
		 * @return
		 */
		static public function fromJSON( json:Object ):MoRankEntity {
			return new MoRankEntity( json.from, json.to, json.rank );
		}
	}
}
