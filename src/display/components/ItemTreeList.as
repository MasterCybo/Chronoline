package display.components {
	import collections.tree.ItemOfList;
	import display.gui.buttons.BtnItemTransfer;
	import display.gui.buttons.BtnPartItem;
	import display.gui.buttons.BtnPartTransfer;
	import flash.events.MouseEvent;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.buttons.AButton;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ItemTreeList extends ASprite {
		
		private var _level:uint;
		
		private var _item:ItemOfList;
		private var _btnBody:AButton;
		private var _btnPlus:AButton;
		private var _width:uint;
		private var _offsetX:uint;
		
		public function ItemTreeList( item:ItemOfList, width:uint = 100, level:uint = 0 ) {
			_item = item;
			_width = width;
			_level = level;
			_offsetX = 20 * _level;
			
			super();
		}
		
		override public function init():* {
			if ( _item.countChildren ) {
				_btnBody = new BtnPartItem( _item.displayName, _width, 30 ).init();
				( _btnBody as BtnPartItem ).checked = _item.checked;
				
				_btnPlus = new BtnPartTransfer().init();
				_btnPlus.eventManager.addEventListener( MouseEvent.CLICK, onClickTransfer );
				_btnPlus.x = _btnBody.x + _btnBody.width - _btnPlus.width;
				
				addChild( _btnBody );
			} else {
				_btnPlus = new BtnItemTransfer( _item.displayName, _width - _offsetX, 30 ).init();
				_btnPlus.x = _offsetX;
				_btnPlus.eventManager.addEventListener( MouseEvent.CLICK, onClickTransfer );
			}
			
			addChild( _btnPlus );
			
			return super.init();
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width(value:Number):void {
			_width = value;
			
			if ( _btnBody ) {
				_btnBody.width = _width;
				_btnPlus.x = _btnBody.width - _btnPlus.width;
			} else {
				_btnPlus.width = _width - _offsetX;
				_btnPlus.x = _offsetX;
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
		
		private function onClickTransfer( ev:MouseEvent ):void {
			ev.stopPropagation();
			
			eventManager.dispatchEvent( ev );
		}
		
	}

}
