package data {
	import events.TimelineEvent;

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
		
		
		private var _timeline:MoPeriod = new MoPeriod();
		private var _range:MoPeriod = new MoPeriod();
		private var _scale:Number = 1;
		private var _baseJD:Number = 0;
		
		private var _eventManager:EventManager = new EventManager();
		
		public function init( beginJD:Number, endJD:Number, baseJD:Number, scale:Number = 1 ):void {
			_timeline.beginJD = beginJD;
			_timeline.endJD = endJD;
			//_range = new MoPeriod( new MoDate( beginJD ), new MoDate( endJD ) );
			_baseJD = baseJD;
			_scale = scale;

			Log.traceText( "*execute* MoTimeline.init" );
			Log.traceText( "_scale : " + _scale );
			
			_eventManager.dispatchEvent( new TimelineEvent( TimelineEvent.INITED ) );
		}
		
		
		/***************************************************************************
		Временная шкала
		***************************************************************************/
		public function get beginJD():Number {
			return _timeline.beginJD;
		}
		
		//public function set beginJD( value:Number ):void {
			//if ( _timeline.beginJD == value ) return;
			//
			//_timeline.beginJD = value;
		//}
		
		public function get endJD():Number {
			return _timeline.endJD;
		}
		
		//public function set endJD( value:Number ):void {
			//if ( _timeline.endJD == value ) return;
			//
			//_timeline.endJD = value;
		//}
		
		public function get duration():Number {
			return _timeline.duration;
		}
		
		public function get scale():Number {
			return _scale;
		}
		
		public function set scale( value:Number ):void {
			if ( value == _scale ) return;
			
			_scale = value;
			
			//Log.traceText( "*execute* MoTimeline.scale : " + _scale );
			
			_eventManager.dispatchEvent( new TimelineEvent( TimelineEvent.SCALE_CHANGED ) );
		}
		
		/***************************************************************************
		Текущая дата
		***************************************************************************/
		public function get baseJD():Number {
			return _baseJD;
		}
		
		public function set baseJD( value:Number ):void {
			if (value == _baseJD) return;
			
			_baseJD = value;
			
			//Log.traceText( "*execute* MoTimeline._baseJD : " + _baseJD );
			
			_eventManager.dispatchEvent( new TimelineEvent( TimelineEvent.BASE_CHANGED ) );
		}
		
		public function get eventManager():EventManager {
			return _eventManager;
		}
	}
}

internal class PrivateKey {
}