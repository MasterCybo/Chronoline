package display.components {
	import com.greensock.TweenMax;

	import constants.TextFormats;

	import data.MoFact;
	import data.MoPicture;

	import display.base.TextApp;

	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	import ru.arslanov.flash.display.ASprite;

	/**
	 * Стопка иконок, пакет, кипа
	 * @author Artem Arslanov
	 */
	public class IconsBundle extends ASprite {
		
		private var _handlerAllComplete:Function;
		
		private var _listIcons:Vector.<FactIcon> = new Vector.<FactIcon>();
		private var _listMoPics:Vector.<MoPicture>;
		private var _rank:Number;
		private var _numLoading:uint;
		private var _tmCollapse:Timer;
		private var _targetOver:ASprite;
		private var _body:ASprite;
		private var _factID:String;
		
		public function IconsBundle( moFact:MoFact, handlerAllComplete:Function = null ) {
			_listMoPics = moFact.categories;
			_rank = moFact.rank;
			_handlerAllComplete = handlerAllComplete;
			
			_factID = moFact.id;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			_body = new ASprite().init();
			addChild( _body );
			
			_tmCollapse = new Timer( Settings.DELAY_CLOSE, 1 );
			_tmCollapse.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			
			var len:uint = _listMoPics.length;
			_numLoading = len;
			
			if ( !len ) {
				var iconEmpty:FactIconEmpty = new FactIconEmpty( _rank ).init();
				addChild( iconEmpty );
				
				var tf:TextApp = new TextApp( _factID, TextFormats.FACT_ID ).init();
				tf.mouseEnabled = false;
				tf.x = int(( iconEmpty.width - tf.width ) * 0.5 );
				tf.y = int(( iconEmpty.height - tf.height ) * 0.5 );
				addChild( tf );
				
				callAllComplete();
				return this;
			}
			
			var icon:FactIcon;
			
			for ( var i:int = 0; i < len; i++ ) {
				icon = new FactIcon( _listMoPics[ i ], _rank, onLoadComplete );
				_listIcons.push( icon );
				icon.init();
			}
			
			eventManager.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			eventManager.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			
			return this;
		}
		
		private function onLoadComplete():void {
			_numLoading--;
			
			if ( !_numLoading ) {
				
				draw();
				
				callAllComplete();
			}
		}
		
		private function draw():void {
			var count:int = _listIcons.length;
			var icon:FactIcon;
			
			while ( count-- ) {
				icon = _listIcons[ count ];
				icon.x = count * Settings.ICON_OFFSET;
				addChild( icon );
			}
		}
		
		private function callAllComplete():void {
			if ( _handlerAllComplete == null )
				return;
			
			if ( _handlerAllComplete.length ) {
				_handlerAllComplete( this );
			} else {
				_handlerAllComplete();
			}
		
		}
		
		private function onMouseOver( ev:MouseEvent ):void {
			_tmCollapse.stop();
			
			if ( _targetOver )
				return;
			
			_targetOver = ev.target as ASprite;
			
			expandTween();
		}
		
		private function onMouseOut( ev:MouseEvent ):void {
			_tmCollapse.start();
		}
		
		private function onTimerComplete( ev:TimerEvent ):void {
			_tmCollapse.stop();
			
			collapseTween();
			
			_targetOver = null;
		}
		
		public function expandTween():void {
			mouseEnabled = false;
			
			var len:uint = _listIcons.length;
			var icon:FactIcon;
			
			var maxW:Number = 0;
			var maxH:Number = 0;
			
			for ( var i:int = 0; i < len; i++ ) {
				icon = _listIcons[ i ];
				TweenMax.to( icon, 0.1, { x: i * ( icon.width + Settings.ICON_SPACE ) } );
				maxH = Math.max( icon.height, maxH );
			}
			
			maxW = len * ( icon.width + Settings.ICON_SPACE );
			
			_body.graphics.clear();
			_body.graphics.beginFill( 0xff00ff, 0 );
			_body.graphics.drawRect( 0, 0, maxW, maxH );
			_body.graphics.endFill();
			
			mouseEnabled = true;
		}
		
		public function collapseTween():void {
			mouseEnabled = false;
			
			_body.graphics.clear();
			
			var len:uint = _listIcons.length;
			var icon:FactIcon;
			
			for ( var i:int = 0; i < len; i++ ) {
				icon = _listIcons[ i ];
				TweenMax.to( icon, 0.1, { x: i * Settings.ICON_OFFSET } );
			}
			
			mouseEnabled = true;
		}
		
		override public function kill():void {
			_handlerAllComplete = null;
			
			_tmCollapse.stop();
			_tmCollapse.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			_tmCollapse = null;
			
			TweenMax.killChildTweensOf( this );
			
			super.kill();
			
			_listMoPics = null;
		}
	}

}