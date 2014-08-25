package display.gui
{
	import constants.LocaleString;

	import controllers.EntitiesRender;
	import controllers.EntityController;
	import controllers.EntityFactsRender;
	import controllers.FactTooltipController;

	import data.MoTimeline;

	import display.components.DateLine;

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
		private var _tooltipController:FactTooltipController;
		private var _entRender:EntitiesRender;
		private var _entCtrl:EntityController;
		private var _curDateMarker:DateLine;
		private var _factRender:EntityFactsRender;
		private var _moTimeline:MoTimeline;

		public function Desktop( width:uint, height:uint )
		{
			_width = width;
			_height = height;

			super();
		}

		override public function init():*
		{
			super.init();

			_moTimeline = MoTimeline.me;

			drawBody();

			_gridScale = new GridScale( _width, _height ).init();
			_container = new ASprite().init();
			_curDateMarker = new DateLine(
					_moTimeline.baseJD,
					Display.stageWidth,
					LocaleString.DATE_YYYY_MONTH_DD,
					Settings.BASE_TEXT_COLOR,
					Settings.BASE_LINE_COLOR,
					Settings.BASE_BACKGROUND_COLOR
			).init();
			_curDateMarker.y = int( _height / 2 );

			_entRender = new EntitiesRender( _container, _width, height );
			_entRender.init();

			_factRender = new EntityFactsRender( _container, height );
			_factRender.init();

			_entCtrl = new EntityController( _container );
			_entCtrl.init();

			_tooltipController = new FactTooltipController( this, _width, height );
			_tooltipController.init();

			_moTimeline.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			_moTimeline.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onChangeBase );
			_moTimeline.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onChangedScale );

			return this;
		}

		private function onInitTimeline( ev:TimelineEvent ):void
		{
			if( !contains( _gridScale ) ) addChild( _gridScale );
			if( !contains( _curDateMarker ) ) addChild( _curDateMarker );
			if( !contains( _container ) ) addChild( _container );

			_entRender.reset();
			_factRender.reset();

			_container.killChildren();

			onChangeBase();
		}

		private function onChangeBase( ev:TimelineEvent = null ):void
		{
			_curDateMarker.jd = _moTimeline.baseJD;

			_entRender.update();
			_factRender.update( _entRender.visibleEntities );
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
			_moTimeline.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );
			_moTimeline.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onChangeBase );
			_moTimeline.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onChangedScale );

			_tooltipController.dispose();
			_entCtrl.dispose();

			super.kill();

			_moTimeline = null;
		}
	}

}
