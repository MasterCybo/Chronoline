package display.objects {
	import collections.EntityManager;

	import data.MoBond;
	import data.MoEntity;
	import data.MoFact;

	import display.base.HintApp;

	import flash.events.MouseEvent;

	import ru.arslanov.core.utils.StringUtils;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.hints.AHintManager;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Bond extends ASprite {
		
		private var _stateNormal:BondView;
		private var _stateOver:BondView;
		private var _moBond:MoBond;
		private var _rank:Number = 0; // 0-1
		private var _width:int;
		private var _height:uint;
		private var _isOver:Boolean;
		
		public function Bond( moBond:MoBond, rank:Number, width:int = 100, height:uint = 20 ) {
			_moBond = moBond;
			_rank = rank;
			_width = width;
			_height = height;
			
			this.name = "bond_" + moBond.id;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			// TODO: Цвета связей должны задаваться в админке, но пока это не реализовано на сервере
			/*_color = Settings.BOND_MARK_COLOR;
			
			switch (_moBond.type) {
				case BindingType.FORMAL:
					_color = BindingColor.FORMAL;
				break;
				case BindingType.KINSHIP:
					_color = BindingColor.KINSHIP;
				break;
				case BindingType.PERSONAL:
					_color = BindingColor.PERSONAL;
				break;
				default:
			}*/
			
			_stateNormal = new BondView( Math.random() * 0xFFFFFF, Settings.BOND_ALPHA, _rank, _width, _height ).init();
			_stateOver = new BondView( Settings.FACT_CLR_OVER, 1, _rank, _width, _height ).init();
			
			updateState();
			
			mouseEnabled = true;
			eventManager.addEventListener( MouseEvent.MOUSE_OVER, hrMouseOver );
			eventManager.addEventListener( MouseEvent.MOUSE_OUT, hrMouseOut );
			
			return this;
		}
		
		private function hrMouseOver( ev:MouseEvent ):void {
			_isOver = true;
			updateState();
			
			var ent1:MoEntity = EntityManager.getItem( moBond.entityUid1 );
			var ent2:MoEntity = EntityManager.getItem( moBond.entityUid2 );
			var moFact:MoFact = ent1.getMoFact( moBond.id );
			
			var title:String = moFact.title;
			
			title = StringUtils.substitute( title, ent1.title, ent2.title );
			
			
			AHintManager.me.displayHint( HintApp, { text:ent1.beginPeriod + "\n" + title, width:200 } );
		}
		
		private function hrMouseOut( ev:MouseEvent ):void {
			_isOver = false;
			updateState();
			
			AHintManager.me.removeHint();
		}
		
		private function updateState():void {
			if ( _isOver ) {
				if ( contains( _stateNormal ) ) {
					removeChild( _stateNormal );
				}
				addChild( _stateOver );
			} else {
				if ( contains( _stateOver ) ) {
					removeChild( _stateOver );
				}
				addChild( _stateNormal );
			}
		}
		
		override public function setSize( width:Number, height:Number, rounded:Boolean = true ):void {
			//super.setSize( width, height, rounded );
			
			_width = width;
			_height = height;
			
			_stateOver.setSize( _width, _height );
			_stateNormal.setSize( _width, _height );
		}
		
		//override public function get width():Number {
			//return _width;
		//}
		//
		//override public function set width( value:Number ):void {
			//if ( value == _width ) return;
			//
			//_width = value;
			//
			//_stateOver.width = _width;
			//_stateNormal.width = _width;
		//}
		//
		//override public function get height():Number {
			//return _height;
		//}
		//
		//override public function set height( value:Number ):void {
			//if ( value == _height ) return;
			//
			//_height = value;
			//
			//_stateOver.height = _height;
			//_stateNormal.height = _height;
		//}
		
		public function get moBond():MoBond {
			return _moBond;
		}
		
		override public function kill():void {
			AHintManager.me.removeHint();
			
			super.kill();
			
			_moBond = null;
		}
	}

}