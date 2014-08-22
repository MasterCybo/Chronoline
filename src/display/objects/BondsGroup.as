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

		public function BondsGroup( listMoBonds:Vector.<MoBond>, width:Number = 0, height:Number = 0 )
		{
			_listMoBonds = listMoBonds;
			_width = width;
			_height = height;

			super();
		}

		override public function init():*
		{
			draw();

			return this;
		}

		override public function setSize( width:Number, height:Number, rounded:Boolean = true ):void
		{
			width = rounded ? Math.round(width) : width;
			height = rounded ? Math.round(height) : height;

			width = Math.max(1, width);
			height = Math.max(1, height);

			if(width == _width) return;
			if(height == _height) return;

			_width = width;
			_height = height;

			update();
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width( value:Number ):void
		{
			value = Math.max(1, value);
			if(value == _width) return;
			_width = value;

			update();
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height( value:Number ):void
		{
			value = Math.max(1, value);
			if(value == _height) return;
			_height = value;

			update();
		}

		public function update():void
		{
			if ( (_width == 0) || (_height == 0) ) return;

			var bond:Bond;

			for each ( bond in _displayBonds ) {
				bond.setSize(_width, _height);
			}
		}

		private function draw():void
		{
			var bond:Bond;
			var moBond:MoBond;
			var len:uint = _listMoBonds.length;

			for ( var i:int = 0; i < len; i++ ) {
				moBond = _listMoBonds[i];

				bond = new Bond( moBond, i / len, _width, _height ).init();
				addChild( bond );

				_displayBonds[ moBond.id + "_" + i ] = bond;
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
