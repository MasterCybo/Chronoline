package display.components {
	import collections.tree.ItemOfList;

	import display.gui.buttons.BtnGroupItem;
	import display.gui.buttons.BtnGroupRelocation;
	import display.gui.buttons.BtnItemRelocation;

	import flash.events.MouseEvent;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.buttons.AButton;
	import ru.arslanov.flash.gui.buttons.AToggle;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ViewItemList extends ASprite {
		
		private var _level:uint;
		
		private var _item:ItemOfList;
		private var _btnBody:AButton;
		private var _btnRelocation:AButton;
		private var _width:uint;
		private var _offsetX:uint;

		public function ViewItemList( item:ItemOfList, width:uint, level:uint ) {
			_item = item;
			_width = width;
			_level = level;
			_offsetX = 20 * _level;

			super();
		}
		
		override public function init():* {
			if ( _item.countChildren ) {
				_btnBody = new BtnGroupItem( _item.displayName, _width, 30 ).init();
				( _btnBody as BtnGroupItem ).checked = _item.checked;
				
				_btnRelocation = new BtnGroupRelocation().init();
				_btnRelocation.eventManager.addEventListener( MouseEvent.CLICK, onClickRelocation );
				_btnRelocation.x = _btnBody.x + _btnBody.width - _btnRelocation.width;

				addChild( _btnBody );
			} else {
				_btnRelocation = new BtnItemRelocation( _item.displayName, _width - _offsetX, 30 ).init();
				_btnRelocation.x = _offsetX;
				_btnRelocation.eventManager.addEventListener( MouseEvent.CLICK, onClickRelocation );
			}
			
			addChild( _btnRelocation );
			
			return super.init();
		}

		public function set modeRemoval( value:Boolean ):void
		{
			if ( !( _btnRelocation is AToggle ) ) return;

			(_btnRelocation as AToggle).checked = value;
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width(value:Number):void {
			_width = value;
			
			if ( _btnBody ) {
				_btnBody.width = _width;
				_btnRelocation.x = _btnBody.width - _btnRelocation.width;
			} else {
				_btnRelocation.width = _width - _offsetX;
				_btnRelocation.x = _offsetX;
			}
		}
		
		override public function get height():Number {
			return super.height;
		}
		
		override public function set height(value:Number):void {
			//super.height = value;
		}
		
		public function get level():uint {
			return _level;
		}
		
		private function onClickRelocation( ev:MouseEvent ):void {
			ev.stopPropagation();
			
			eventManager.dispatchEvent( ev );
		}
		
	}

}
