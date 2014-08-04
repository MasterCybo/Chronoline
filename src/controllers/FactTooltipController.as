package controllers
{
	import data.MoFact;
	import data.MoTimeline;

	import display.components.FactTooltip;
	import display.objects.Fact;

	import events.TimelineEvent;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class FactTooltipController
	{

		private var _host:ASprite;
		private var _tooltips:Dictionary/*FactTooltip*/ = new Dictionary( true ); // MoFact.id = FactTooltip
		private var _clickMoFact:MoFact;
		private var _overMoFact:MoFact;

		private var _width:Number;
		private var _height:Number;
		private var _scale:Number;
		private var _ptClick:Point;
		private var _ptOver:Point;

		private var _isMouseMove:Boolean;

		private var _minJD:Number;
		private var _maxJD:Number;

		public function FactTooltipController( host:ASprite, width:Number, height:Number )
		{
			_host = host;
			_width = width;
			_height = height;
		}

		public function init():void
		{
			_host.eventManager.addEventListener( MouseEvent.MOUSE_OVER, onFactOver );
			_host.eventManager.addEventListener( MouseEvent.MOUSE_OUT, onFactOut );

			Display.stageAddEventListener( MouseEvent.MOUSE_DOWN, onStageDown );
			Display.stageAddEventListener( MouseEvent.MOUSE_UP, onStageUp );

			MoTimeline.me.eventManager.addEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onMoveTimeline );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onScaleTimeline );
		}

		public function dispose():void
		{
			_host.eventManager.removeEventListener( MouseEvent.MOUSE_OVER, onFactOver );
			_host.eventManager.removeEventListener( MouseEvent.MOUSE_OUT, onFactOut );

			Display.stageRemoveEventListener( MouseEvent.MOUSE_DOWN, onStageDown );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageUp );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onStageMove );

			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.INITED, onInitTimeline );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onMoveTimeline );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onScaleTimeline );

			_clickMoFact = null;
			_overMoFact = null;

			_host = null;
			_tooltips = null;
			_ptClick = null;
			_ptOver = null;
		}
		
		/**
		 Обработчики Timeline
		 */
		private function onInitTimeline( event:TimelineEvent ):void
		{
			if ( _clickMoFact ) {
				killTooltip( _clickMoFact.id );
				_clickMoFact = null;
			}

			if ( _overMoFact ) {
				killTooltip( _overMoFact.id );
				_overMoFact = null;
			}

			_tooltips = new Dictionary( true );

			updateBounds();
		}

		private function onScaleTimeline( ev:TimelineEvent ):void
		{
			updateBounds();

			if ( _clickMoFact ) updateTooltip( _clickMoFact );
			if ( _overMoFact ) updateTooltip( _overMoFact );
		}

		private function onMoveTimeline( ev:TimelineEvent ):void
		{
			updateBounds();

			if ( _clickMoFact ) updateTooltip( _clickMoFact );
			if ( _overMoFact ) updateTooltip( _overMoFact );
		}

		/**
		 Обработчики Stage
		 */
		private function onStageDown( ev:MouseEvent ):void
		{
			Display.stageAddEventListener( MouseEvent.MOUSE_MOVE, onStageMove );
		}

		private function onStageMove( ev:MouseEvent ):void
		{
			_isMouseMove = true;
		}

		private function onStageUp( ev:MouseEvent ):void
		{
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onStageMove );
			
			if ( !_isMouseMove ) {
				var fact:Fact = ev.target.parent as Fact;
				
				if ( fact ) {
					if ( _clickMoFact && ( fact.moFact != _clickMoFact ) ) {
						killTooltip( _clickMoFact.id );
						_clickMoFact = null;
					}
					_clickMoFact = fact.moFact;
					_ptClick = _ptOver.clone();
				} else {
					if ( _clickMoFact && ( ev.target == _host ) ) {
						killTooltip( _clickMoFact.id );
						_clickMoFact = null;
					}
				}
			}
			
			_isMouseMove = false;
		}

		/**
		 Обработчики Fact
		 */
		private function onFactOver( ev:MouseEvent ):void
		{
			var fact:Fact = ev.target.parent as Fact;
			if ( !fact ) return;
			if ( fact.moFact == _clickMoFact ) return;

			_overMoFact = fact.moFact;
			_ptOver = _host.globalToLocal( fact.localToGlobal( fact.pivotPoint ) );

			updateTooltip( _overMoFact );
		}

		private function onFactOut( ev:MouseEvent ):void
		{
			if ( !( ev.target.parent is Fact ) ) return;

			var fact:Fact = ev.target.parent as Fact;

			if ( fact.moFact != _clickMoFact ) {
				var tooltip:FactTooltip = _tooltips[ _overMoFact.id ];
				if ( tooltip ) {
					killTooltip( _overMoFact.id );
					_overMoFact = null;
				}
			}
		}

		private function updateTooltip( moFact:MoFact ):void
		{
//			Log.traceText( "*execute* FactTooltipController.updateTooltip" );
//			Log.traceText( "\t(moFact == _clickMoFact) : " + (moFact == _clickMoFact) );
//			Log.traceText( "\t(moFact == _overMoFact) : " + (moFact == _overMoFact) );
			
			if ( !moFact ) return;

			var tooltip:FactTooltip = _tooltips[ moFact.id ];
			if ( tooltip ) {
				// Если тултип выходит за границы экрана - скрываем его, но не уничтожаем
				if ( ( moFact.period.middle < _minJD ) || ( moFact.period.middle > _maxJD ) ) {
					if ( _host.contains( tooltip ) ) {
						_host.removeChild( tooltip );
					}
					return;
				} else {
					if ( !_host.contains( tooltip ) ) {
						_host.addChild( tooltip );
					}
				}
			} else {
				tooltip = displayTooltip( moFact );
			}

//			trace( "(moFact == _clickMoFact) : " + (moFact == _clickMoFact) );

			tooltip.x = (moFact == _clickMoFact) ? _ptClick.x : _ptOver.x;
			tooltip.y = dateToY( moFact.period.middle );
		}

		private function displayTooltip( moFact:MoFact ):FactTooltip
		{
			var tooltip:FactTooltip = _tooltips[ moFact.id ];

			if ( !tooltip ) {
				tooltip = new FactTooltip( moFact ).init();

				_tooltips[ moFact.id ] = tooltip;
			}

			if ( !_host.contains( tooltip ) ) {
				_host.addChild( tooltip );
			}

			return tooltip;
		}

		private function killTooltip( factID:String ):void
		{
			var tooltip:FactTooltip = _tooltips[ factID ];

			if ( !tooltip ) return;

			tooltip.kill();
			delete _tooltips[ factID ];
		}

		private function updateBounds():void
		{
			var halfJD:Number = _height * 0.5 / MoTimeline.me.scale;
			_minJD = MoTimeline.me.baseJD - halfJD;
			_maxJD = MoTimeline.me.baseJD + halfJD;

			var newDuration:Number = _maxJD - _minJD;
			_scale = _height / Math.max( 1, newDuration );
		}

		private function dateToY( jd:Number ):Number
		{
			return _scale * ( jd - _minJD );
		}

	}

}