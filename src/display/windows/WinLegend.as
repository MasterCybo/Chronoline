package display.windows
{
	import data.MoETag;

	import display.components.ItemLegend;

	import net.ReqETagList;

	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.gui.layout.VBox;
	import ru.arslanov.flash.gui.windows.AWindowsManager;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class WinLegend extends WindowApp
	{

		static public const WINDOW_NAME:String = "winLegend";
		static public const SPACE:uint = 10;

		private var _listETags:Vector.<MoETag>;
		private var _vbox1:VBox;
		private var _vbox2:VBox;

		public function WinLegend( width:int = -1, height:int = -1 )
		{
//			super( WINDOW_NAME, Settings.WIN_LEGEND_WIDTH, height );
			super( WINDOW_NAME, uint( Display.stageWidth / 2 ), height );
		}


		override public function init():*
		{
			super.init();
			super.alignPosition = AWindowsManager.POSITION_RB;

			_listETags = new Vector.<MoETag>();

			_vbox1 = new VBox( SPACE ).init();
			addChildToContent( _vbox1 );

			_vbox2 = new VBox( SPACE ).init();
			addChildToContent( _vbox2 );

			App.httpManager.addRequest( new ReqETagList(), onSuccessful, onError );

			return this;
		}

		private var _sizeIcon:Number;

		private function onSuccessful( req:ReqETagList ):void
		{
			var json:Object = JSON.parse( String( req.responseData ) );
			var list:Array = json.tags as Array;

			for each ( var item:Object in list ) {
				_listETags.push( MoETag.parse( item ) );
			}

			var num:int = _listETags.length;
			_sizeIcon = Math.max( ( super.height - SPACE * num ) / num, Settings.LEGEND_MIN_SIZE );

			_vbox1.setXY( _sizeIcon / 2, _sizeIcon / 2 );

			var itemLegend:ItemLegend;
			for ( var i:int = 0; i < _listETags.length; i++ ) {
				var eTag:MoETag = _listETags[i];
				itemLegend = new ItemLegend( eTag, _sizeIcon, _sizeIcon, onDrawComplete ).init();
			}
		}

		private function onDrawComplete( target:ItemLegend ):void
		{
			if ( _vbox1.height < ( height - 2 * _sizeIcon ) ) {
				_vbox1.addChildAndUpdate( target );
			} else {
				_vbox2.x = _vbox1.x + _vbox1.width + SPACE;
				_vbox2.y = _vbox1.y;
				_vbox2.addChildAndUpdate( target );
			}
		}

		private function onError():void
		{
			Log.traceText( "*execute* WinLegend.onError" );
		}


		override public function kill():void
		{
			_listETags.length = 0;
			_listETags = null;

			super.kill();
		}
	}

}