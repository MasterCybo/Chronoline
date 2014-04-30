package controllers {
	import data.MoFact;
	import data.MoTimeline;

	import display.components.PopupInfo;
	import display.objects.Fact;

	import events.TimelineEvent;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class PopupController {
		
		private var _host:ASprite;
		private var _popups:Dictionary /*PopUpInfo*/ = new Dictionary( true ); // MoFact.id = PopUpInfo
		private var _lockedMoFact:MoFact;
		private var _curMoFact:MoFact;
		
		private var _width:Number;
		private var _height:Number;
		private var _scale:Number;
		private var _ptLock:Point;
		private var _ptPopup:Point;
		
		//private var _rgBegin:MoDate;
		//private var _rgEnd:MoDate;
		
		private var _isDragged:Boolean;
		private var _minJD:Number;
		private var _maxJD:Number;
		
		public function PopupController( host:ASprite, width:Number, height:Number ) {
			_host = host;
			_width = width;
			_height = height;
		}
		
		public function init():void {
			//_rgBegin = MoTimeline.me.rangeBegin;
			//_rgEnd = MoTimeline.me.rangeEnd;

//			updateBoundsJD();
			
			_host.eventManager.addEventListener( MouseEvent.CLICK, onClickFact );
			_host.eventManager.addEventListener( MouseEvent.MOUSE_OVER, onOverFact );
			_host.eventManager.addEventListener( MouseEvent.MOUSE_OUT, onOutFact );
			_host.eventManager.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_host.eventManager.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			Display.stageAddEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			Display.stageAddEventListener( MouseEvent.MOUSE_UP, onMouseUpStage );

			MoTimeline.me.eventManager.addEventListener( TimelineEvent.BASE_CHANGED, onChangedBase );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.SCALE_CHANGED, onChangedScale );
		}
		
		private function onMouseDown( ev:MouseEvent ):void {
//			_host.eventManager.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			Display.stageAddEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		private function onMouseMove( ev:MouseEvent ):void {
			updatePosition( _curMoFact );
			_isDragged = true;
		}
		
		private function onMouseUp( ev:MouseEvent ):void {
//			_host.eventManager.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );

			if ( !_isDragged && _lockedMoFact ) {
				removePopup( _lockedMoFact );
				_lockedMoFact = null;
			}

			_isDragged = false;
		}

		private function onMouseUpStage( ev:MouseEvent ):void {
			if ( !_isDragged && _lockedMoFact ) {
				removePopup( _lockedMoFact );
				_lockedMoFact = null;
			}

			_isDragged = false;
		}
		
		private function onOverFact( ev:MouseEvent ):void {
			if ( !( ev.target.parent is Fact ) ) return;

			Log.traceText( "*execute* PopupController.onOverFact" );

			var fact:Fact = ev.target.parent as Fact;
			
			if ( fact.moFact == _lockedMoFact ) return;
			
			_curMoFact = fact.moFact;
			
			_ptPopup = _host.globalToLocal( fact.localToGlobal( fact.pivotPoint ) );
			
			displayPopup( _curMoFact );
		}
		
		private function onOutFact( ev:MouseEvent ):void {
			if ( !( ev.target.parent is Fact ) ) return;
			
			var fact:Fact = ev.target.parent as Fact;
			
			if ( fact.moFact != _lockedMoFact ) {
				var popup:PopupInfo =  _popups[ _curMoFact.id ];
				if ( popup ) {
					removePopup( _curMoFact );
					_curMoFact = null;
				}
			}
		}
		
		private function onClickFact( ev:MouseEvent ):void {
			Log.traceText( "*execute* PopupController.onClickFact" );
			//if ( !( ev.target.parent is Fact ) ) return;

			Log.traceText( "_isDragged : " + _isDragged );

			if ( _isDragged ) {
				_isDragged = false;
				return;
			}
			
			var fact:Fact = ev.target.parent as Fact;
			
			if ( !fact ) {
				if ( _lockedMoFact ) {
				//if ( !fact || _lockedMoFact ) {
					removePopup( _lockedMoFact );
					_lockedMoFact = null;
				}
				return;
			}
			
			if ( fact.moFact == _lockedMoFact ) return;
			
			if ( _lockedMoFact ) {
				removePopup( _lockedMoFact );
				_lockedMoFact = null;
			}
			
			_lockedMoFact = fact.moFact;
			//_ptLock = _host.globalToLocal( fact.parent.localToGlobal( fact.pivotPoint ) );
			_ptLock = _ptPopup.clone();
		}
		
		private function onChangedScale( ev:TimelineEvent ):void {
//			updateBoundsJD();

			if ( !_lockedMoFact ) return;

			updatePosition( _lockedMoFact );
		}
		
		private function onChangedBase( ev:TimelineEvent ):void {
//			updateBoundsJD();

			if ( !_lockedMoFact ) return;

			updatePosition( _lockedMoFact );
		}

		private function updateBoundsJD():void {
			var halfJD:Number = (Display.stageHeight - Settings.TOOLBAR_HEIGHT) * 0.5 / MoTimeline.me.scale;
			_minJD = MoTimeline.me.baseJD - halfJD;
			_maxJD = MoTimeline.me.baseJD + halfJD;
		}
		
		private function updatePosition( moFact:MoFact ):void {
			updatePopup( moFact );
		}
		
		private function displayPopup( moFact:MoFact ):void {
//			Log.traceText( "*execute* PopupController.displayPopup" );
			var popup:PopupInfo = _popups[ moFact.id ];
			
			if ( !popup ) {
				popup = new PopupInfo( moFact ).init();
				
				_popups[ moFact.id ] = popup;
			}
			
			updatePopup( moFact );
		}
		
		private function updatePopup( moFact:MoFact ):void {
			if( !moFact ) return;

			var popup:PopupInfo = _popups[ moFact.id ];

			updateBoundsJD();

//			Log.traceText( "moFact.period.middle : " + moFact.period.middle );


			if ( ( moFact.period.middle < _minJD ) || ( moFact.period.middle > _maxJD ) ) {
				if ( _host.contains( popup ) ) {
					_host.removeChild( popup );
				}
				return;
			}
			
			var newDuration:Number = _maxJD - _minJD;
			_scale = _height / ( newDuration == 0 ? 1 : newDuration );
			
			popup.x = moFact == _lockedMoFact ? _ptLock.x : _ptPopup.x;
			popup.y = moFact == _lockedMoFact ? dateToY( moFact.period.middle ) : _ptPopup.y;

//			Log.traceText( "popup.x, y : " + popup.x + ", " + popup.y );

			if ( !_host.contains( popup ) ) {
				_host.addChild( popup );
			}
		}
		
		private function removePopup( moFact:MoFact ):void {
			var popup:PopupInfo = _popups[ moFact.id ];
			
			if ( !popup ) return;
			
			popup.kill();
			delete _popups[ moFact.id ];
			
			//_popupX = 0;
		}

		private function dateToY( date:Number ):Number {
			return _scale * ( date - _minJD );
		}
		
		public function dispose():void {
			_host.eventManager.removeEventListener( MouseEvent.CLICK, onClickFact );
			_host.eventManager.removeEventListener( MouseEvent.MOUSE_OVER, onOverFact );
			_host.eventManager.removeEventListener( MouseEvent.MOUSE_OUT, onOutFact );
			_host.eventManager.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onMouseUpStage );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.BASE_CHANGED, onChangedBase );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.SCALE_CHANGED, onChangedScale );
			
			_lockedMoFact = null;
			_curMoFact = null;
			
			_host = null;
			_popups = null;
			_ptLock = null;
			_ptPopup = null;
		}
	}

}