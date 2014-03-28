package display.gui {
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
		private var _render:Render;
		
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
			
			_popupController = new PopupController( this, _width, _height );
			_popupController.init();
			
			
			_render = new Render( _container, new Rectangle( 0, 0, _width, _height ) );
			_render.start();
			
			
			//Notification.add( BindingDisplayNotice.NAME, onDisplayBond );
			//Notification.add( BindingRemoveNotice.NAME, onRemoveBinding );
			
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
			
			super.kill();
		}
	}

}
