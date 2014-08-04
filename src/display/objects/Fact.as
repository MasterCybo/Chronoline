package display.objects
{
	import data.MoFact;

	import display.components.FactDateLabel;
	import display.components.IconsPile;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import ru.arslanov.flash.display.ASprite;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Fact extends ASprite
	{

		private var _moFact:MoFact;
		private var _height:Number;
		private var _body:FactBody;
		private var _labelBegin:FactDateLabel;
		private var _labelEnd:FactDateLabel;
		private var _isFree:Boolean = true;
		private var _iPile:IconsPile;
		private var _depth:int;
		private var _posButton:Point = new Point();

		public function Fact()
		{
			super();
		}

		/**
		 * Воскрешение объекта с новыми параметрами
		 * @param    moFact
		 * @param    height
		 */
		public function initialize( moFact:MoFact, height:Number = 100 ):void
		{
			_moFact = moFact;
			_height = Math.max( 1, height );

			if ( !_body ) {
				_body = new FactBody( _height ).init();
			}

			if ( !contains( _body ) ) {
				addChild( _body );
			}

			_iPile = new IconsPile( moFact, updatePositionPile );
			_iPile.init();
			_iPile.eventManager.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			_iPile.eventManager.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			addChild( _iPile );

			_isFree = false;
		}

		private function update():void
		{
			if ( _body ) _body.height = height;

			updatePositionPile();
		}

		private function updatePositionPile():void
		{
			if ( !_iPile ) return;

			_iPile.x = _body.x + _body.width;
			_iPile.y = ( _body.height - _iPile.height ) * 0.5;
		}

		private function onMouseOver( ev:MouseEvent ):void
		{
			// Запоминаем текущую глубину и помещаем на самый верх
			_depth = parent.getChildIndex( this );
			parent.setChildIndex( this, parent.numChildren - 1 );

			//Log.traceText( "moFact : " + moFact );

			_body.stateOver = true;

			if ( !_labelBegin ) {
				_labelBegin = new FactDateLabel( moFact.period.beginJD ).init();
			}

			if ( !_labelEnd ) {
				_labelEnd = new FactDateLabel( moFact.period.endJD ).init();
			}

			//var labHeight:Number = _labelEnd.getHeightLabel() + _labelBegin.getHeightLabel();
			var labHeight:Number = Math.max( _labelEnd.getHeightLabel(), _labelBegin.getHeightLabel() ) + 2;

			if ( _labelBegin ) {
				_labelBegin.offsetY = _body.height < labHeight ? -(labHeight + 10) / 2 : 0;
			}

			if ( _labelEnd ) {
				_labelEnd.offsetY = _body.height < labHeight ? (labHeight + 10) / 2 : 0;
			}

			_labelBegin.x = int( -_labelBegin.width );
			_labelEnd.x = int( -_labelEnd.width );

			_labelBegin.y = int( _body.y );
			_labelEnd.y = int( _body.y + _body.height );

			if ( !contains( _labelBegin ) ) addChild( _labelBegin );
			if ( !contains( _labelEnd ) ) addChild( _labelEnd );
		}

		private function onMouseOut( ev:MouseEvent ):void
		{
			// Возвращаем на предыдущую глубину
			if ( parent ) {
				parent.setChildIndex( this, Math.min( parent.numChildren - 1, _depth ) );
			}
			
			_body.stateOver = false;

			if ( contains( _labelBegin ) ) removeChild( _labelBegin );
			if ( contains( _labelEnd ) ) removeChild( _labelEnd );
		}

		override public function set height( value:Number ):void
		{
			if ( value == _height ) return;

			_height = Math.max( 1, value );

			update();
		}

		override public function get height():Number
		{
			return _height;
		}

		public function get moFact():MoFact
		{
			return _moFact;
		}

		public function get pivotPoint():Point
		{
			return new Point( _iPile.x + _iPile.height * 0.5, _iPile.y + _iPile.height * 0.5 );
		}

		/**
		 * Флаг, сигнализирующий свободен ли объект
		 */
		public function get isFree():Boolean
		{
			return _isFree;
		}

		public function setFree():void
		{
			_isFree = true;

			if ( _labelBegin ) {
				_labelBegin.kill();
				_labelBegin = null;
			}

			if ( _labelEnd ) {
				_labelEnd.kill();
				_labelEnd = null;
			}

			_iPile.kill();
			_iPile = null;

			_moFact = null;
			_height = 0;
		}

		override public function kill():void
		{
			_moFact = null;

			super.kill();
		}
	}

}
