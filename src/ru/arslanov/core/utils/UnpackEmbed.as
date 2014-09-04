package ru.arslanov.core.utils {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class UnpackEmbed {
		
		private var _asset:MovieClip;
		private var _content:MovieClip;
		private var _onComplete:Function;
		
		public function UnpackEmbed( assetClass:Class, onComplete:Function ) {
			_onComplete = onComplete;
			
			_asset = new assetClass();
			
			var loader:Loader = Loader( _asset.getChildAt( 0 ) );
			var info:LoaderInfo = loader.contentLoaderInfo;
			info.addEventListener( Event.COMPLETE, onLoadComplete );
		}
		
		private function onLoadComplete( ev:Event ):void {
			var info:LoaderInfo = LoaderInfo( ev.target );
			info.removeEventListener( Event.COMPLETE, onLoadComplete );
			
			_content = info.loader.content as MovieClip;
			
			if ( _onComplete != null ) {
				if ( _onComplete.length == 1 ) {
					_onComplete( this );
				} else {
					_onComplete();
				}
			}
		}
		
		public function get content():MovieClip {
			return _content;
		}
		
		public function get asset():MovieClip {
			return _asset;
		}
		
		public function kill():void {
			_asset = null;
			_content = null;
			_onComplete = null;
		}
	}

}