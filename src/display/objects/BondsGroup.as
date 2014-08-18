/**
 * Copyright (c) 2014 SmartHead. All rights reserved.
 */
package display.objects
{
	import data.MoBond;

	import flash.utils.Dictionary;

	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BondsGroup extends ASprite
	{
		private var _listMoBonds:Vector.<MoBond>;
		private var _displayBonds:Dictionary = new Dictionary(true);
		private var _width:Number = 0;
		private var _height:Number = 0;

		public function BondsGroup( listMoBonds:Vector.<MoBond> )
		{
			_listMoBonds = listMoBonds;

			super();
		}

		override public function init():*
		{
			update();

			return this;
		}

		override public function setSize( width:Number, height:Number, rounded:Boolean = true ):void
		{
			width = rounded ? Math.round(width) : width;
			height = rounded ? Math.round(height) : height;

			if(width == _width) return;
			if(height == _height) return;

			_width = width;
			_height = height;

			update();
		}

		public function update():void
		{
			var bond:Bond;
			var moBond:MoBond;
			var len:uint = _listMoBonds.length;

			for ( var i:int = 0; i < len; i++ ) {
				moBond = _listMoBonds[i];

				bond = _displayBonds[ moBond.id ];

				if ( !bond ) {
					bond = new Bond( moBond, i / len, _width, _height ).init();
					addChild( bond );

					_displayBonds[ moBond.id + "_" + i ] = bond;
				}

				if ( bond ) {
					bond.setSize( _width, _height );
				}
			}
		}

		override public function kill():void
		{
			_listMoBonds = null;
			_displayBonds = null;

			super.kill();
		}
	}
}
