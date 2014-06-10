package display.gui
{
	import controllers.BondsRender;
	import controllers.EntitiesRender;
	import controllers.EntityController;
	import controllers.FactsRender;
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
	public class Desktop extends ASprite
	{

		private var _width:uint;
		private var _height:uint;
		private var _container:ASprite;
		private var _gridScale:GridScale;
		private var _popupController:PopupController;
		private var _entRender:EntitiesRender;
		private var _bondRender:BondsRender;
		private var _entCtrl:EntityController;
		private var _curDateMarker:DateGraduation;
		private var _factRender:FactsRender;

		public function Desktop( width:uint, height:uint )
		{
			_width = width;
			_height = height;

			super();
		}

		override public function init():*
		{
			super.init();

			drawBody();

			_gridScale = new GridScale( _width, _height ).init();
			_container = new ASprite().init();
			_curDateMarker = new DateGraduation(
					MoTimeline.me.baseJD,
					Display.stageWidth,
					Settings.BASE_TEXT_COLOR,
					Settings.BASE_LINE_COLOR,
					Settings.BASE_BACKGROUND_COLOR
			).init();
			_curDateMarker.y = int( _height / 2 );

//			addChild( _gridScale );
//			addChild( _curDateMarker );
//			addChild( _container );

			_entRender = new EntitiesRender( _container, _width, height );
			_entRender.init();

			_factRender = new FactsRender( _container, height );
			_factRender.init();

			_bondRender = new BondsRender( _container, _width, height );
			_bondRender.init();

			_entCtrl = new EntityController( _container );
			_entCtrl.init();

			_popupController = new PopupController( this, _width, height );
			_popupController.init();

			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onChangeBase );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onChangedScale );

			return this;
		}

		private function onInitTimeline( ev:TimelineEvent ):void
		{
			if( !contains( _gridScale ) ) addChild( _gridScale );
			if( !contains( _curDateMarker ) ) addChild( _curDateMarker );
			if( !contains( _container ) ) addChild( _container );

			_container.killChildren();

			onChangeBase();

//			_entRender.update();
//			_factRender.update( _entRender.visibleEntities );
//			_bondRender.update();
		}

		private function onChangeBase( ev:TimelineEvent = null ):void
		{
			_curDateMarker.jd = MoTimeline.me.baseJD;

			_entRender.update();
			_factRender.update( _entRender.visibleEntities );
			_bondRender.update( _factRender.visibleFacts );
		}

		private function onChangedScale( event:TimelineEvent ):void
		{
			_entRender.update();
			_factRender.update( _entRender.visibleEntities );
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width( value:Number ):void
		{
			_width = value;
			_gridScale.width = _width;
			_curDateMarker.width = _width;

			drawBody();
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height( value:Number ):void
		{
			_height = value;
			_gridScale.height = _height;
			_curDateMarker.y = int( _height / 2 );

			drawBody();
		}

		private function drawBody():void
		{
			graphics.clear();
			graphics.beginFill( 0xFF0000, 0 );
			graphics.drawRect( 0, 0, _width, _height );
			graphics.endFill();
		}

		override public function kill():void
		{
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onChangeBase );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onChangedScale );

			_popupController.dispose();
			_entCtrl.dispose();

			super.kill();

		}
	}

}
