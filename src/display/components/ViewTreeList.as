package display.components {
	import collections.tree.ItemOfList;
	import collections.tree.TreeList;

	import com.adobe.utils.DictionaryUtil;

	import display.gui.buttons.BtnPartItem;
	import display.skins.ScrollbarThumb;

	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.AVScroller;
	import ru.arslanov.flash.gui.layout.VBox;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ViewTreeList extends ASprite {
		private var _width:uint;
		private var _height:uint;
		private var _vbox:VBox;
		private var _vscroller:AVScroller;
		
		private var _treeList:TreeList;
		private var _poolViews:Dictionary /*ItemTreeList*/; // Пул кнопок, чтобы не создавать каждый раз новые. keyName = ItemTreeList
		private var _displayItems:Dictionary /*ItemOfList*/; // ItemTreeList = ItemOfList
		
		public function ViewTreeList( width:uint, height:uint ) {
			_width = width;
			_height = height;
			
			super();
		}
		
		override public function init():* {
			_treeList = new TreeList();
			_poolViews = new Dictionary( true );
			_displayItems = new Dictionary( true );
			
			_vbox = new VBox( 1, 1 ).init();
			addChild( _vbox );
			
			_vscroller = new AVScroller( new Rectangle( 0, 0, _width, _height ), new ScrollbarThumb().init() ).init();
			_vscroller.addChildToContent( _vbox );
			addChild( _vscroller );
			
			return super.init();
		}
		
		public function setupList( treeList:TreeList ):void {
			_treeList = treeList;
			_treeList.onUpdate = update;
			
			update();
		}
		
		private function compareByKeyName( item1:ItemOfList, item2:ItemOfList ):Number {
			if ( item1.keyName > item2.keyName ) return 1;
			if ( item1.keyName < item2.keyName ) return -1;
			return 0;
		}
		
		public function update():void {
			var list:Vector.<ItemOfList>= getSortedVector( _treeList.rootChildren );
			
			/*
			// Дебаг
			var len:uint = list.length;
			var item:ItemOfList;
			for (var i:int = 0; i < len; i++) {
				item = list[i];
				
				Log.traceText( "item : " + item );
			}
			*/
			
			redrawAndUpdate( list, 0, 0 );
		}
		
		/***************************************************************************
		   Обновление вида
		 ***************************************************************************/
		//{ region
		private function redrawAndUpdate( list:Vector.<ItemOfList>, idx:int, level:uint ):void {
			//if (!list.length ) return;
			
			redraw( list, idx, level );
			
			_vbox.update();
			_vscroller.update();
		}
		
		private function redraw( list:Vector.<ItemOfList>, idx:uint, level:uint ):void {
			var len:uint = list.length;
			
			//if ( !len ) return;
			
			var view:ItemTreeList;
			var item:ItemOfList;
			var i:uint;
			
			for ( i = 0; i < len; i++ ) {
				item = list[ i ];
				view = getViewItem( item, level );
				
				if (!item.viewed ) {
					//Log.traceText( item + " не видимый" );
					if ( _displayItems[ view ] ) {
						//Log.traceText( "... но отображается - удаляем!" );
						_vbox.removeChild( view );
						delete _displayItems[ view ];
					}
				} else {
					//Log.traceText( item + " видимый" );
					
					if (!_vbox.contains( view ) ) {
						//Log.traceText( "... но НЕ отображается - добавляем!" );
						_displayItems[ view ] = item;
						_vbox.addChildAt( view, idx + i );
					}
					
					if ( item.checked && ( item.countChildren ) ) {
						//Log.traceText( "... и открыт - отображаем детей!" );
						
						redraw( getSortedVector( item.children ), idx + i + 1, level + 1 );
					}
				}
			}
			
			removeFromCache( _treeList.getCacheRemovedItems() );
			
			_treeList.clearCacheRemovedItems();
			
			//Log.traceText( "_vbox.numChildren : " + _vbox.numChildren );
		}
		
		private function removeFromCache( list:Array ):void {
			if ( !list.length ) return;
			
			var view:ItemTreeList;
			var item:ItemOfList;
			
			var len:uint = list.length;
			for ( var i:uint = 0; i < len; i++ ) {
				item = list[i];
				view = _poolViews[ item.keyName ];
				
				if ( _displayItems[ view ] ) {
					_vbox.removeChild( view );
					delete _displayItems[ view ];
				}
				
				if ( item.countChildren ) {
					removeFromCache( DictionaryUtil.getValues( item.children ) );
				}
			}
		}
		//} endregion
		
		/***************************************************************************
		Получение вида элемента
		***************************************************************************/
		private function getViewItem( item:ItemOfList, level:uint = 0 ):ItemTreeList {
			if ( !item ) {
				throw new ArgumentError( "item is null!" );
			}
			
			var iView:ItemTreeList = _poolViews[ item.keyName ];
			
			if ( !iView ) { // если у элемента нет вида, то создаём вид и помещаем в пул
				iView = new ItemTreeList( item, _width, level ).init();
				iView.eventManager.addEventListener( MouseEvent.CLICK, onClickItem );
				_poolViews[ item.keyName ] = iView;
			}
			
			iView.customData = item;
			iView.width = _width - 5;
			
			return iView;
		}
		
		/***************************************************************************
		Обработчик нажатия кнопки
		***************************************************************************/
		private function onClickItem( ev:MouseEvent ):void {
			Log.traceText( "*execute* ViewTreeList.onClickItem" );
			
			var btn:BtnPartItem = ev.target as BtnPartItem;
			
			if ( !btn ) return;
			
			var iView:ItemTreeList = ev.currentTarget as ItemTreeList;
			var idx:int = _vbox.getChildIndex( iView );
			
			Log.traceText( "idx : " + idx );
			
			var item:ItemOfList = _displayItems[ iView ];
			item.checked = !item.checked;
			
			redrawAndUpdate( getSortedVector( item.children ), idx + 1, 1 );
		}
		
		private function getSortedVector( dict:Dictionary ):Vector.<ItemOfList> {
			return Vector.<ItemOfList>( DictionaryUtil.getValues( dict ) ).sort( compareByKeyName );
		}
		
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width(value:Number):void {
			_width = value;
			
			updateSize();
			updateSizeItems();
		}
		
		override public function get height():Number {
			return _height;
		}
		
		override public function set height(value:Number):void {
			_height = value;
			
			updateSize();
		}
		
		private function updateSize():void {
			_vscroller.setViewPort( new Rectangle( 0, 0, width, height ) );
		}
		
		private function updateSizeItems():void {
			var len:uint = _vbox.numChildren;
			var iview:ASprite;
			for (var i:int = 0; i < len; i++) {
				iview = _vbox.getChildAt( i ) as ASprite;
				iview.width = width - 5;
			}
			
			//_vbox.update();
		}
	}

}
