package display.gui {
	import collections.BondsManager;

	import controllers.EntitiesRender;
	import controllers.PopupController;

	import data.MoBond;
	import data.MoFact;
	import data.MoTimeline;

	import display.objects.Bond;
	import display.objects.Entity;

	import events.BondDisplayNotice;
	import events.BondRemoveNotice;
	import events.TimelineEvent;

	import flash.utils.Dictionary;

	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Desktop extends ASprite {
		
		private var _visibleBindings:Dictionary /*Binding*/; // MoBinding = Binding;
		private var _cacheBindings:Dictionary /*Binding*/; // MoBinding = Binding;
		
		private var _space:Number; // расстояние между сущностями
		private var _scale:Number;
		private var _width:uint;
		private var _height:uint;
		private var _rangeBegin:MoDate;
		private var _rangeEnd:MoDate;
		private var _container:ASprite;
		private var _gridScale:GridScale;
		private var _isResize:Boolean;
		private var _oldDuration:Number;
		private var _popupController:PopupController;
		
		public function Desktop( width:uint, height:uint ) {
			_width = width;
			_height = height;
			
			super();
		}
		
		override public function init():* {
			_visibleBindings = new Dictionary( true );
			_cacheBindings = new Dictionary( true );
			
			_gridScale = new GridScale( _width, _height ).init();
			_container = new ASprite().init();
			
			addChild( _gridScale );
			addChild( _container );
			
			var entRender:EntitiesRender = new EntitiesRender( _container, _width, height );
			entRender.init();
			
			_popupController = new PopupController( this );
			_popupController.init();
			
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.TIMELINE_RESIZE, onTimelineChanged );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_RESIZE, onTimelineChanged );
			MoTimeline.me.eventManager.addEventListener( TimelineEvent.RANGE_MOVE, onTimelineChanged );
			
			//Notification.add( BindingDisplayNotice.NAME, onDisplayBond );
			//Notification.add( BindingRemoveNotice.NAME, onRemoveBinding );
			
			return super.init();
		}
		
		// Вызывается по UpdateChronolineNotice
		private function update():void {
			_container.killChildren();
			
			//_arrEnts = EntityManager.getArrayEntities();
			
			//_space = _width / _arrEnts.length;
			
			_rangeBegin = MoTimeline.me.rangeBegin;
			_rangeEnd = MoTimeline.me.rangeEnd;
			
			updateBindingsPosition(); // temp
			
			updateScaleAndRedraw();
			centeringContainer();
		}
		
		/***************************************************************************
		   Обработчики изменения глобальной временной шкалы
		 ***************************************************************************/
		private function onTimelineChanged( ev:TimelineEvent ):void {
			//Log.traceText( "_rangeBegin - _rangeEnd : " + _rangeBegin.begin.getValue() + " - " + _rangeEnd.end.getValue() );
			
			updateScaleAndRedraw();
			
			centeringContainer();
		}
		
		/**
		 * Обновляем масштаб и перерисовываем
		 */
		private function updateScaleAndRedraw():void {
			if ( !_rangeEnd || !_rangeEnd )
				return;
			
			var rdur:Number = _rangeEnd.getValue() - _rangeBegin.getValue();
			_scale = _height / ( rdur == 0 ? 1 : rdur );
			
			_isResize = _oldDuration != rdur;
			
			//Log.traceText( "_isResize : " + _isResize );
			
			updateBindingsPosition(); // temp
			
			_oldDuration = rdur;
		}
		
		/***************************************************************************
		   Обработка СВЯЗЕЙ
		 ***************************************************************************/
		//{ region СВЯЗИ
		private function onDisplayBond( notice:BondDisplayNotice ):void {
			//Log.traceText( "*execute* Desktop.onDisplayBond" );
			//notice.idMoMilestone
			
			Log.traceText( "_container.numChildren : " + _container.numChildren );
			
			var bonds:Vector.<MoBond> = BondsManager.getItems( notice.factID );
			
			//Log.traceText( "notice.idMoMilestone : " + notice.idMoMilestone );
			//Log.traceText( "bonds : " + bonds );
			
			if ( !bonds )
				return;
			
			var len:uint = bonds.length;
			var moBind:MoBond;
			var bind:Bond;
			var ent1:Entity;
			var ent2:Entity;
			var moStone:MoFact;
			var widthBind:Number;
			var heightBind:Number;
			
			for ( var i:int = 0; i < len; i++ ) {
				moBind = bonds[ i ];
				
				if ( !_visibleBindings[ moBind ] ) {
					ent1 = _container.getChildByName( "ent_" + moBind.entityUid1 ) as Entity;
					ent2 = _container.getChildByName( "ent_" + moBind.entityUid2 ) as Entity;
					
					Log.traceText( "moBind.entityUid1 : " + moBind.entityUid1 );
					
					Log.traceText( "ent1 : " + ent1 );
					Log.traceText( "ent2 : " + ent2 );
					
					
					moStone = ent1.moEntity.getMoFact( moBind.id );
					
					bind = _cacheBindings[ moBind ];
					
					widthBind = ent2.x - ent1.x - Settings.ENT_WIDTH;
					heightBind = _scale * moStone.period.duration;
					
					if ( !bind ) {
						bind = new Bond( moBind, i + 1, len, widthBind, heightBind ).init();
						_cacheBindings[ moBind ] = bind;
					}
					
					bind.x = ent1.x + Settings.ENT_WIDTH;
					bind.y = dateToY( moStone.period.dateBegin.getValue() );
					bind.setSize( widthBind, heightBind );
					
					if ( !_container.contains( bind ) ) {
						_container.addChild( bind );
						_visibleBindings[ moBind ] = bind;
					}
					
				}
			}
		}
		
		private function onRemoveBond( notice:BondRemoveNotice ):void {
			var bonds:Vector.<MoBond> = BondsManager.getItems( notice.factID );
			
			if ( !bonds )
				return;
			
			var len:uint = bonds.length;
			var moBind:MoBond;
			var bind:Bond;
			
			for ( var i:int = 0; i < len; i++ ) {
				moBind = bonds[ i ];
				
				bind = _visibleBindings[ moBind ];
				
				if ( bind ) {
					_container.removeChild( bind );
					
					delete _visibleBindings[ moBind ];
					
					if ( !_cacheBindings[ moBind ] ) {
						_cacheBindings[ moBind ] = bind;
					}
				}
			}
		}
		
		private function updateBindingsPosition():void {
			var bind:Bond;
			var moBind:MoBond;
			var ent1:Entity;
			var ent2:Entity;
			var moStone:MoFact;
			
			for each ( bind in _visibleBindings ) {
				moBind = bind.moBond;
				
				ent1 = _container.getChildByName( "ent_" + moBind.entityUid1 ) as Entity;
				ent2 = _container.getChildByName( "ent_" + moBind.entityUid2 ) as Entity;
				
				moStone = ent1.moEntity.getMoFact( moBind.id );
				
				bind.x = ent1.x + Settings.ENT_WIDTH;
				bind.y = dateToY( moStone.period.dateBegin.getValue() );
				bind.setSize( ent2.x - ent1.x - Settings.ENT_WIDTH, _scale * moStone.period.duration );
			}
		}
		
		//} endregion
		
		private function calcX( num:uint ):Number {
			return num * _space;
		}
		
		private function dateToY( date:Number ):Number {
			//return Math.round( _scale * ( date - _rangeBegin.begin.getValue() ) );
			return _scale * ( date - _rangeBegin.getValue() );
		}
		
		private function centeringContainer():void {
			//Log.traceText( "*execute* Desktop.centeringContainer" );
			//var ww:Number = _entViews.length * Settings.ENT_WIDTH + ( _entViews.length - 1 ) * _space;
			//_container.x = Math.round(( _width - _container.width ) / 2 );
			_container.x = 400;
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width( value:Number ):void {
			_width = value;
			
			//if ( _arrEnts ) {
				//_space = Math.round( _width / _arrEnts.length );
				//_space = _width / _arrEnts.length;
				//
				//updateEntityViews();
				centeringContainer();
			//}
			
			_gridScale.width = width;
		}
		
		override public function get height():Number {
			return _height;
		}
		
		override public function set height( value:Number ):void {
			_height = value;
			
			updateScaleAndRedraw();
			
			_gridScale.height = height;
		}
		
		//} endregion
		
		override public function kill():void {
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.TIMELINE_RESIZE, onTimelineChanged );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.RANGE_RESIZE, onTimelineChanged );
			MoTimeline.me.eventManager.removeEventListener( TimelineEvent.RANGE_MOVE, onTimelineChanged );
			
			_popupController.dispose();
			
			super.kill();
			
			_rangeBegin = null;
			_rangeEnd = null;
			
		}
	}

}
