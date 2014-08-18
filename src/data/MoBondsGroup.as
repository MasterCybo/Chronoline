/**
 * Copyright (c) 2014 SmartHead. All rights reserved.
 */
package data
{
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MoBondsGroup extends ModelBase
	{
		public var idEntity1:String = "";
		public var idEntity2:String = "";

		public var listBonds:Vector.<MoBond> = new Vector.<MoBond>();

		public function MoBondsGroup( idFact:String, idEntity1:String, idEntity2:String )
		{
			this.idEntity1 = idEntity1;
			this.idEntity2 = idEntity2;

			super( idFact );
		}
	}
}
