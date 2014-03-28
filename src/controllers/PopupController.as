package controllers {
	import data.MoDate;
	import data.MoFact;
	import data.MoTimeline;
	import display.components.PopupInfo;
	import display.objects.Fact;
	import events.TimelineEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	
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
		private var _popupX:Number;
		private var _popupLockX:Number;
		
		private var _rgBegin:MoDate;
		private var _rgEnd:MoDate;
		
		private var _isDragged:Boolean;
		
		public function PopupController( host:ASprite, width:Number, height:Number ) {
			_host = host;
			_width = width;
			_height = height;
		}
		
		public function init():void {
			_rgBegin = MoTimeline.me.rangeBegin;
			_rgEnd = MoTimeline.me.rangeEnd;
			
			_host.eventManager.addEventListener( MouseEvent.CLICK, onClickFact );
			_host.eventManager.addEventListener( MouseEvent.MOUSE_OVER, onOverFact );
			_host.eventManager.addEventListener( MouseEvent.MOUSE_OUT, onOutFact );
			_host.eventManager.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_host.eventManager.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_RESIZE, onResizeRange );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_MOVE, onMoveRange );
		}
		
		private function onMouseDown( ev:MouseEvent ):void {
			_host.eventManager.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		private function onMouseMove( ev:MouseEvent ):void {
			_isDragged = true;
		}
		
		private function onMouseUp( ev:MouseEvent ):void {
			_host.eventManager.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		private function onOverFact( ev:MouseEvent ):void {
			if ( !( ev.target.parent is Fact ) ) return;
			
			var fact:Fact = ev.target.parent as Fact;
			
			if ( fact.moFact == _lockedMoFact ) return;
			
			_curMoFact = fact.moFact;
			
			_popupX = _host.globalToLocal( fact.parent.localToGlobal( fact.pivotPoint ) ).x;
			
			var newDuration:Number = _rgEnd.jd - _rgBegin.jd;
			_scale = _height / ( newDuration == 0 ? 1 : newDuration );
			
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
			//if ( !( ev.target.parent is Fact ) ) return;
			
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
			_popupLockX = _host.globalToLocal( fact.parent.localToGlobal( fact.pivotPoint ) ).x;
		}
		
		private function onResizeRange( ev:TimelineEvent ):void {
			if ( !_lockedMoFact ) return;
			
			updatePosition( _lockedMoFact );
		}
		
		private function onMoveRange( ev:TimelineEvent ):void {
			if ( !_lockedMoFact ) return;
			
			updatePosition( _lockedMoFact );
		}
		
		private function updatePosition( moFact:MoFact ):void {
			updatePopup( moFact );
		}
		
		private function updatePopup( moFact:MoFact ):void {
			var popup:PopupInfo = _popups[ moFact.id ];
			
			if ( ( moFact.period.middle < _rgBegin.jd ) || ( moFact.period.middle > _rgEnd.jd ) ) {
				if ( _host.contains( popup ) ) {
					_host.removeChild( popup );
				}
				return;
			}
			
			var newDuration:Number = _rgEnd.jd - _rgBegin.jd;
			_scale = _height / ( newDuration == 0 ? 1 : newDuration );
			
			popup.x = moFact == _lockedMoFact ? _popupLockX : _popupX;
			popup.y = dateToY( moFact.period.dateBegin.jd );
			
			if ( !_host.contains( popup ) ) {
				_host.addChild( popup );
			}
		}
		
		private function displayPopup( moFact:MoFact ):void {
			var popup:PopupInfo = _popups[ moFact.id ];
			
			if ( !popup ) {
				popup = new PopupInfo( moFact ).init();
				
				_popups[ moFact.id ] = popup;
			}
			
			updatePopup( moFact );
		}
		
		private function removePopup( moFact:MoFact ):void {
			var popup:PopupInfo = _popups[ moFact.id ];
			
			if ( !popup ) return;
			
			popup.kill();
			delete _popups[ moFact.id ];
			
			//_popupX = 0;
		}

		private function dateToY( date:Number ):Number {
			return _scale * ( date - _rgBegin.jd );
		}
		
		public function dispose():void {
			_host.eventManager.removeEventListener( MouseEvent.CLICK, onClickFact );
			_host.eventManager.removeEventListener( MouseEvent.MOUSE_OVER, onOverFact );
			_host.eventManager.removeEventListener( MouseEvent.MOUSE_OUT, onOutFact );
			_host.eventManager.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.RANGE_RESIZE, onResizeRange );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.RANGE_MOVE, onMoveRange );
			
			_lockedMoFact = null;
			_curMoFact = null;
			
			_host = null;
			_popups = null;
		}
	}

}