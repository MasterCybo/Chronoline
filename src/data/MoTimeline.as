package data {
	import events.TimelineEvent;
	import flash.events.EventDispatcher;
	import ru.arslanov.core.events.EventManager;
	import ru.arslanov.core.utils.Log;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class MoTimeline {
		
		//{ region Инициализация синглтона
		private static var _instance:MoTimeline;
		
		public static function get me():MoTimeline {
			if ( _instance == null ) {
				_instance = new MoTimeline( new PrivateKey() );
			}
			return _instance;
		}
		
		public function MoTimeline( key:PrivateKey ):void {
			if ( !key ) {
				throw new Error( "Error: Instantiation failed: Use MoTimeline.me instead of new." );
			}
		}
		//} endregion
		
		
		private var _timeline:MoPeriod;
		private var _range:MoPeriod;
		private var _scale:Number = 1;
		private var _curDateJD:Number = 0;
		
		private var _eventManager:EventManager;
		
		public function init( moBegin:MoDate = null, moEnd:MoDate = null ):void {
			if ( !moBegin ) moBegin = new MoDate();
			if ( !moEnd ) moEnd = new MoDate();
			
			_timeline = new MoPeriod( moBegin, moEnd );
			
			_range = new MoPeriod( moBegin.clone(), moEnd.clone() );
			
			_eventManager = new EventManager( new EventDispatcher() );
		}
		
		
		/***************************************************************************
		Временная шкала
		***************************************************************************/
		public function setTimePeriod( beginJD:Number, endJD:Number ):void {
			//Log.traceText( "*execute* MoTimeline.setMeantime" );
			_timeline.dateBegin.jd = beginJD;
			_timeline.dateEnd.jd = endJD;
			
			_eventManager.dispatchEvent( new TimelineEvent( TimelineEvent.TIMELINE_RESIZE ) );
		}
		
		public function get beginDate():MoDate {
			return _timeline.dateBegin;
		}
		
		public function set beginDate( moDate:MoDate ):void {
			if ( _timeline.dateBegin.equals( moDate ) ) return;
			
			_timeline.dateBegin = moDate;
		}
		
		public function get endDate():MoDate {
			return _timeline.dateEnd;
		}
		
		public function set endDate( moDate:MoDate ):void {
			if ( _timeline.dateEnd.equals( moDate ) ) return;
			
			_timeline.dateEnd = moDate;
		}
		
		public function get duration():Number {
			return _timeline.duration;
		}
		
		public function get scale():Number {
			return _scale;
		}
		
		public function set scale( value:Number ):void {
			if ( value == _scale ) return;
			
			_scale = value;
			
			Log.traceText( "*execute* MoTimeline.scale : " + _scale );
			
			_eventManager.dispatchEvent( new TimelineEvent( TimelineEvent.SCALE_CHANGED ) );
		}
		
		/***************************************************************************
		Текущая дата
		***************************************************************************/
		public function get currentDateJD():Number {
			return _curDateJD;
		}
		
		public function set currentDateJD( value:Number ):void {
			if (value == _curDateJD) return;
			
			_curDateJD = value;
			
			Log.traceText( "*execute* MoTimeline.currentDateJD : " + _curDateJD );
			
			_eventManager.dispatchEvent( new TimelineEvent( TimelineEvent.CURRENT_DATE_CHANGED ) );
		}
		
		/***************************************************************************
		Выделенный диапазон
		***************************************************************************/
		
		public function get rangeBegin():MoDate {
			return _range.dateBegin;
		}
		
		public function get rangeEnd():MoDate {
			return _range.dateEnd;
		}
		
		/**
		 * Изменение границ диапазона
		 * @param	beginJD
		 * @param	endJD
		 */
		public function setRange( beginJD:Number, endJD:Number ):void {
			var oldDur:Number = _range.duration;
			
			_range.dateBegin.jd = beginJD;
			_range.dateEnd.jd = endJD;
			
			if ( oldDur == _range.duration ) { // Если длина диапазона не изменилась - это смещение
				_eventManager.dispatchEvent( new TimelineEvent( TimelineEvent.RANGE_MOVE ) );
			} else {
				_eventManager.dispatchEvent( new TimelineEvent( TimelineEvent.RANGE_RESIZE ) );
			}
		}
		
		public function get eventManager():EventManager {
			return _eventManager;
		}
	}
}

internal class PrivateKey {
}