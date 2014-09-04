package ru.arslanov.flash.gui.controllers {
	import flash.events.MouseEvent;
	import ru.arslanov.flash.gui.buttons.AToggle;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GroupTogglers {
		
		public var onSelect:Function;
		
		public var selectedItems:Vector.<AToggle>;
		public var multiSelection:Boolean;
		
		private var _prevButton:AToggle;
		private var _items:Vector.<AToggle>;
		
		public function GroupTogglers( multiSelection:Boolean = false ) {
			this.multiSelection = multiSelection;
			
			_items = new Vector.<AToggle>();
			selectedItems = new Vector.<AToggle>();
		}
		
		public function addItem( toggle:AToggle ):AToggle {
			toggle.eventManager.addEventListener( MouseEvent.CLICK, hrMouseClick );
			_items.push( toggle );
			
			checkItem( toggle );
			
			return toggle;
		}
		
		public function addItems( items:Array /*AToggle*/ ):void {
			var len:uint = items.length;
			for ( var i:int = 0; i < len; i++ ) {
				addItem( items[ i ] );
			}
		}
		
		private function hrMouseClick( ev:MouseEvent ):void {
			var toggle:AToggle = ev.target as AToggle;
			
			checkItem( toggle );
			
			callChanged();
		}
		
		private function checkItem( toggle:AToggle ):void {
			var idx:int;
			
			if ( toggle.checked ) {
				if ( !multiSelection ) {
					if ( _prevButton ) {
						_prevButton.enabled = true;
						_prevButton.checked = false;
						
						idx = selectedItems.indexOf( _prevButton );
						selectedItems.splice( idx, 1 );
					}
					toggle.enabled = false;
					_prevButton = toggle;
				}
				
				selectedItems.push( toggle );
			} else {
				idx = selectedItems.indexOf( toggle );
				if ( idx != -1 ) {
					selectedItems.splice( idx, 1 );
				}
				
				if ( !multiSelection ) {
					toggle.enabled = true;
				}
			}
		}
		
		public function selectItems( indexes:Array ):void {
			var len:uint = indexes.length;
			var maxIdx:uint = _items.length;
			var toggle:AToggle;
			
			for ( var i:int = 0; i < len; i++ ) {
				toggle = _items[ Math.max( 0, Math.min( indexes[ i ], maxIdx ) ) ];
				toggle.checked = true;
				checkItem( toggle );
			}
		}
		
		private function callChanged():void {
			if ( onSelect != null ) {
				if ( onSelect.length > 0 ) {
					onSelect( this );
				} else {
					onSelect();
				}
			}
		}
		
		public function deselectAll():void {
			var len:int = selectedItems.length;
			
			for (var i:int = 0; i < len; i++) {
				selectedItems[i].checked = false;
				checkItem( selectedItems[i] );
				i--;
				len--;
			}
			
			selectedItems.length = 0;
		}
		
		public function clear():void {
			_prevButton = null;
			_items.length = 0;
			selectedItems.length = 0;
		}
		
		public function dispose():void {
			clear();
			
			onSelect = null;
		}
	
	}

}