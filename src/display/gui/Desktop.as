package display.gui {
	import controllers.BondsRender;
	import controllers.EntitiesRender;
	import controllers.EntityController;
	import controllers.PopupController;

	import data.MoTimeline;

	import display.components.DateGraduation;

	import events.TimelineEvent;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Desktop extends ASprite {
		
		private var _width:uint;
		private var _height:uint;
		private var _container:ASprite;
		private var _gridScale:GridScale;
		private var _popupController:PopupController;
		private var _entRender:EntitiesRender;
		private var _bondRender:BondsRender;
		private var _entCtrl:EntityController;
		private var _curDateMarker:DateGraduation;
		
		public function Desktop( width:uint, height:uint ) {
			_width = width;
			_height = height;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			_gridScale = new GridScale( _width, _height ).init();
			_container = new ASprite().init();
			_curDateMarker = new DateGraduation( MoTimeline.me.baseJD, Display.stageWidth, 0xFF8000, 0xFF8000 ).init();
			_curDateMarker.y = int( _height / 2 );
			
			addChild( _gridScale );
			addChild( _curDateMarker );
			addChild( _container );
			
			_entRender = new EntitiesRender( _container, _width, height );
			_entRender.init();
			
			_bondRender = new BondsRender( _container, _width, height );
			_bondRender.init();
			
			_entCtrl = new EntityController( _container );
			_entCtrl.init();
			
			_popupController = new PopupController( this, _width, height );
			_popupController.init();
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, updateBaseDate );
			
			return this;
		}
		
		private function onInitTimeline( ev:TimelineEvent ):void {
			updateBaseDate();
			
			_container.killChildren();
			
			_entRender.update();
			_bondRender.update();
		}
		
		private function updateBaseDate( ev:TimelineEvent = null ):void {
			_curDateMarker.jd = MoTimeline.me.baseJD;
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width( value:Number ):void {
			_width = value;
			_gridScale.width = _width;
			_curDateMarker.width = _width;
		}
		
		override public function get height():Number {
			return _height;
		}
		
		override public function set height( value:Number ):void {
			_height = value;
			_gridScale.height = _height;
			_curDateMarker.y = int( _height / 2 );
		}
		
		//} endregion
		
		override public function kill():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );
			
			_popupController.dispose();
			_entCtrl.dispose();
			
			super.kill();
			
		}
	}

}
