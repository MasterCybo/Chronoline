package display.gui {
<<<<<<< HEAD
	import controllers.BondsRender;
	import controllers.EntitiesRender;
	import controllers.EntityController;
=======
>>>>>>> 7765d46036a6e3d94ef8935b22b5158b497180f3
	import controllers.PopupController;
	import controllers.Render;
	import flash.geom.Rectangle;
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
<<<<<<< HEAD
		private var _entRender:EntitiesRender;
		private var _bondRender:BondsRender;
		private var _entCtrl:EntityController;
=======
		private var _render:Render;
>>>>>>> 7765d46036a6e3d94ef8935b22b5158b497180f3
		
		public function Desktop( width:uint, height:uint ) {
			_width = width;
			_height = height;
			
			super();
		}
		
		override public function init():* {
			super.init();
			
			_gridScale = new GridScale( _width, _height ).init();
			_container = new ASprite().init();
			
			addChild( _gridScale );
			addChild( _container );
			
			_popupController = new PopupController( this, _width, _height );
			_popupController.init();
			
			
<<<<<<< HEAD
			_entCtrl = new EntityController( _container );
			_entCtrl.init();
			
			_popupController = new PopupController( this, _width, height );
			_popupController.init();
=======
			_render = new Render( _container, new Rectangle( 0, 0, _width, _height ) );
			_render.start();
>>>>>>> 7765d46036a6e3d94ef8935b22b5158b497180f3
			
			
<<<<<<< HEAD
			return this;
		}
		
		private function onTimelineChanged( ev:TimelineEvent ):void {
			_container.killChildren();
=======
			//Notification.add( BindingDisplayNotice.NAME, onDisplayBond );
			//Notification.add( BindingRemoveNotice.NAME, onRemoveBinding );
>>>>>>> 7765d46036a6e3d94ef8935b22b5158b497180f3
			
			return super.init();
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
			_render.dispose();
			
			_popupController.dispose();
			_entCtrl.dispose();
			
			super.kill();
		}
	}

}
