package ru.arslanov.flash.display {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AMovieClipContainer extends ASprite {
		
		static public var enterFrameDispatcher:EventDispatcher;
		static private var _isAllPlaying:Boolean = true;
		
		public var frameStep:Number = 1;
		
		private var _mc:MovieClip;
		private var _isAutoPlay:Boolean;
		private var _isAutoPlayReversed:Boolean;
		private var _isReversed:Boolean;
		private var _frame:Object = 1;
		private var _totalFrames:Number = 0;
		
		
		static public function fromClass( className:Class, autoPlay:Boolean = true, reversed:Boolean = false ):AMovieClipContainer {
			return new AMovieClipContainer( new className(), autoPlay, reversed );
		}
		
		static public function stopAll():void {
			_isAllPlaying = false;
		}
		
		static public function resumeAll():void {
			_isAllPlaying = true;
		}
		
		/***************************************************************************
		Constructor
		***************************************************************************/
		public function AMovieClipContainer( mc:MovieClip, autoPlay:Boolean = true, reversed:Boolean = false ) {
			mc.stop();
			
			_mc = mc;
			_isAutoPlay = autoPlay;
			_isAutoPlayReversed = reversed;
			
			enterFrameDispatcher = this;
			
			super();
		}
		
		override public function init():* {
			_totalFrames = _mc.totalFrames;
			
			if ( !contains( _mc ) ) addChild( _mc );
			
			if ( _isAutoPlay ) {
				play( _isAutoPlayReversed );
			} else {
				stop();
			}
			
			//override me
			
			return super.init();
		}
		
		public function play( reverse:Boolean = false ):void {
			stop();
			
			_isReversed = reverse;
			
			if ( _isReversed ) {
				enterFrameDispatcher.addEventListener( Event.ENTER_FRAME, handlerPlayReverse );
			} else {
				enterFrameDispatcher.addEventListener( Event.ENTER_FRAME, handlerEnterFrame );
				_mc.play();
			}
		}
		
		public function stop():void {
			if ( _isReversed ) {
				enterFrameDispatcher.removeEventListener( Event.ENTER_FRAME, handlerPlayReverse );
				_isReversed = false;
			} else {
				enterFrameDispatcher.removeEventListener( Event.ENTER_FRAME, handlerEnterFrame );
				_mc.stop();
			}
		}
		
		private function handlerEnterFrame( ev:Event ):void {
			if ( !_isAllPlaying ) {
				if ( _mc.isPlaying ) {
					_mc.stop();
				}
			} else {
				if ( !_mc.isPlaying ) {
					_mc.play();
				}
			}
		}
		
		private function handlerPlayReverse( ev:Event ):void {
			if ( !_isAllPlaying ) return;

			_frame = Number( _frame ) - Math.abs( frameStep );
			setFrame( _frame );
		}
		
		public function gotoAndStop( frame:Object ):void {
			stop();
			setFrame( frame );
		}
		
		public function gotoAndPlay( frame:Object, reverse:Boolean = false ):void {
			stop();
			setFrame( frame );
			play( reverse );
		}
		
		private function setFrame( frame:Object ):void {
			if ( frame is String ) {
				_mc.gotoAndStop( frame );
			} else {
				trace( "1 frame : " + frame );
				
				frame = ( Number( frame ) % totalFrames ) + ( Number( frame ) < 0 ? totalFrames : 0);
				trace( "2 frame : " + frame );
				_mc.gotoAndStop( Math.round( Number( frame ) ) );
			}
			_frame = _mc.currentFrame;
		}
		
		
		public function gotoNextFrame():void {
			_frame = Number( _frame ) + frameStep;
			gotoAndStop( _frame );
		}
		
		public function gotoPrevFrame():void {
			_frame = Number( _frame ) - Math.abs( frameStep );
			gotoAndStop( _frame );
		}
		
		public function get totalFrames():Number {
			return _totalFrames;
		}
		
		public function get currentFrame():Number {
			return _mc.currentFrame;
		}
		
		override public function get width():Number {
			return _mc.width;
		}
		
		override public function set width( value:Number ):void {
			_mc.width = value;
		}
		
		override public function get height():Number {
			return _mc.height;
		}
		
		override public function set height( value:Number ):void {
			_mc.height = value;
		}
		
		override public function get scaleX():Number {
			return _mc.scaleX;
		}
		
		override public function set scaleX( value:Number ):void {
			_mc.scaleX = value;
		}
		
		override public function get scaleY():Number {
			return _mc.scaleY;
		}
		
		override public function set scaleY( value:Number ):void {
			_mc.scaleY = value;
		}
		
		public function get movieClip():MovieClip {
			return _mc;
		}
		
		override public function kill():void {
			stop();
			
			if ( _mc ) removeChild( _mc );
			_mc = null;
			
			super.kill();
		}
		
	}

}