package display.gui {
	import controllers.BondsRender;
	import controllers.EntitiesRender;
	import controllers.PopupController;
	import data.MoTimeline;
	import events.TimelineEvent;
	import ru.arslanov.flash.display.ASprite;
	
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
		
		public function Desktop( width:uint, height:uint ) {
			_width = width;
			_height = height;
			
			super();
		}
		
		override public function init():* {
			_gridScale = new GridScale( _width, _height ).init();
			_container = new ASprite().init();
			
			addChild( _gridScale );
			addChild( _container );
			
			_entRender = new EntitiesRender( _container, _width, height );
			_entRender.init();
			
			_bondRender = new BondsRender( _container, _width, height );
			_bondRender.init();
			
			_popupController = new PopupController( this, _width, height );
			_popupController.init();
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.TIMELINE_RESIZE, onTimelineChanged );
			
			return super.init();
		}
		
		private function onTimelineChanged( ev:TimelineEvent ):void {
			_container.killChildren();
			
			_entRender.update();
			_bondRender.update();
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width( value:Number ):void {
			_width = value;
			
			_gridScale.width = width;
		}
		
		override public function get height():Number {
			return _height;
		}
		
		override public function set height( value:Number ):void {
			_height = value;
			
			_gridScale.height = height;
		}
		
		//} endregion
		
		override public function kill():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.TIMELINE_RESIZE, onTimelineChanged );
			
			_popupController.dispose();
			
			super.kill();
			
		}
	}

}
