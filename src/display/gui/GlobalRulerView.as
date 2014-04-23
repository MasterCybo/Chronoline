package display.gui {
	import data.MoTimeline;

	import display.base.TextApp;

	import flash.display.CapsStyle;
	import flash.utils.Dictionary;

	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GlobalRulerView extends ASprite {
		private var _width:Number;
		private var _height:Number;
		private var _markers:Dictionary/*ASprite*/; // Пара ключ-значение date:ASprite
		private var _dateBegin:MoDate;
		private var _dateEnd:MoDate;
		private var _duration:Number = 0;
		private var _div:Number = 0;
		private var _timeStep:Number = 0;
		private var _dy:Number = 0;
		private var _p:Number = 0;
		private var _s0:Number = 0;
		private var _s:Number = 0;
		private var _readyForDisplay:Array;
		
		public function GlobalRulerView( width:Number, height:Number ) {
			_width = width;
			_height = height;
			_timeStep = 10;
			
			super();
		}
		
		override public function init():* {
			mouseEnabled = mouseChildren = false;
			
			redraw();
			
			return super.init();
		}
		
		private function redraw():void {
			killChildren();
			
			_markers = new Dictionary( true );
			
			_dateBegin = MoTimeline.me.beginDate;
			_dateEnd = MoTimeline.me.endDate;
			
			_duration = _dateEnd.jd - _dateBegin.jd;
			
			_div = _duration / _timeStep;
			_p = _duration / _div;
			_s0 = _s = _height / _div;
			
			_readyForDisplay = [];
			
			var hh:Number = _height;
			_height = 0;
			height = hh;
		}
		
		/***************************************************************************
		ПЕРЕРИСОВКА
		***************************************************************************/
		private function update():void {
			var marker:ASprite;
			var label:String = "";
			var i:int;
			
			for ( i = 0; i <= _div; i++ ) {
				label = "" + ( _dateBegin.getGregorian().year + Math.ceil( i * _p ) );
				
				_readyForDisplay.push( label );
			}
			
			// Значение альфы
			var aa:Number = Math.max( 0, 2 - _s0 / _s ); // _s0 / _s = 1..2
			
			var len:int = _readyForDisplay.length;
			var count:uint;
			
			for ( i = 0; i < len; i++ ) {
				marker = _markers[ _readyForDisplay[i] ];
				
				if ( !marker ) {
					marker = createMarker( _readyForDisplay[i], i == 0 ? "bottom" : ( i == (len-1) ? "top" : "center" ) );
					_markers[ _readyForDisplay[i] ] = marker;
					
					addChild( marker );
					count++; // debug counter
				}
				
				var a:Number = i % 2;
				if ( a != 0 ) {
					marker.alpha = aa;
				}
				
				marker.y = i * _s;
			}
			
			//Log.traceText( "Added : " + count );
			
			count = 0;
			
			for (var name:String in _markers) {
				if ( _readyForDisplay.indexOf( name ) == -1 ) {
					_markers[ name ].kill();
					delete _markers[ name ];
					
					count++; // debug counter
				}
			}
			
			_readyForDisplay.length = 0;
			
			//Log.traceText( "Removed count : " + count );
			//Log.traceText( "numChildren : " + numChildren );
			
			/*
			// Simple draw for debug
			killChildren();
			
			for ( var i:int = 0; i <= _div; i++ ) {
				var a:Number = i % 2;
				if ( a != 0 ) {
					alpha = aa
				} else {
					alpha = 1;
				}
				
				//Log.traceText( "alpha : " + alpha );
				
				label = "" + (dateBegin + Math.ceil( i * _p ) );
				
				marker = createMarker( label );
				marker.y = i * _s;
				addChild( marker );
			}
			*/
		}
		
		private function createMarker( text:String, pos:String = "center" ):ASprite {
			var marker:ASprite = new ASprite().init();
			
			var tf:TextApp = new TextApp( text ).init();
			
			switch ( pos ) {
				case "top":
					tf.y = -tf.height;
				break;
				case "bottom":
					tf.y = 0;
				break;
				default:
					tf.y = -int( tf.height / 2 );
			}
			
			
			marker.graphics.lineStyle( 1, Settings.TL_DASH_COLOR, 1, true, "none", CapsStyle.NONE );
			marker.graphics.moveTo( tf.width, 0 );
			marker.graphics.lineTo( _width, 0 );
			
			marker.addChild( tf );
			
			return marker;
		}
		
		/***************************************************************************
		ГЕТТЕРЫ / СЕТТЕРЫ
		***************************************************************************/
		override public function get height():Number {
			return _height;
		}
		
		override public function set height( value:Number ):void {
			if ( value == _height ) return;
			
			_height = value;
			
			var n:Number = 1;
			var hh:Number = 0;
			do {
				n *= 2;
				//hh = Math.pow( 2, a );
				hh = _s0 * n;
			} while ( hh <= _height );
			
			_div = n;
			_p = _duration / _div;
			_s = _height / _div;
			
			update();
		}
	}
}