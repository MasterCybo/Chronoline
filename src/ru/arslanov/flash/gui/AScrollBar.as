package ru.arslanov.flash.gui
{
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.events.ASliderEvent;

	/**
	 * Скролбар - графический-компонент, который изменяет значение свойста от 0 до 1 с помощью мышки.
	 * Позволяет задавать визуальное элементы: подложку и ползунок.
	 * Поддерживает управление колесом мыши.
	 * @author Artem Arslanov
	 */
	public class AScrollBar extends ASlider
	{
		public var minThumbHeight:Number = 5;
		
		private var _scrollTarget:Object;

		private var _maskSize:Number = 0;

		private var _thumbAutoSize:Boolean = true;
		private var _param:String;
		private var _minValue:Number = 0;
		private var _maxValue:Number = 0;
		private var _range:Number = 0;

		public function AScrollBar( size:Number = 100, body:ASprite = null, thumb:ASprite = null )
		{

			super( size, body, thumb );
		}

		override public function init():*
		{
			super.init();

			super.eventManager.addEventListener( ASliderEvent.CHANGE_VALUE, onChangeValue );

			return this;
		}

		private function onChangeValue( event:ASliderEvent ):void
		{
			updateTargetPosition();
		}

		/*==========================================================================
		 Геттеры / Сеттеры
		 ===========================================================================*/
		/**
		 * Размер скроллера
		 * @param value:Number
		 */
		override public function set size( value:Number ):void
		{
			super.size = value;

			update(); // replaced setMaskSize( _maskSize );
		}

		public function getScrollTarget():Object
		{
			return _scrollTarget;
		}

		/**
		 * Задание целевого объекта и его параметра, который будет изменяться скроллером. 
		 * @param object:Object - любой объект, свойство которого можно менять.
		 * @param paramName:String - имя свойства, подлежащего изменениям.
		 */
		public function setScrollTarget( object:Object, paramName:String = "y" ):void
		{
			if ( !object ) {
				throw new ArgumentError( "The value of the 'object' should not be null." );
			}

			if ( !(paramName in object) ) {
				throw new ArgumentError( "The property '" + paramName + "' is not present in the " + object + "." );
			}

			_scrollTarget = object;
			_param = paramName;
		}

		/**
		 * Установка диапазона прокруки. Для дисплейного объекта, это могут быть значения y и y + height.
		 * @param minValue:Number - положение целевого объекта, соответствующее значению position = 0.
		 * @param maxValue:Number - положение целевого объекта, соответствующее значению position = 1.
		 */
		public function setScrollRange( minValue:Number, maxValue:Number ):void
		{
			_minValue = minValue;
			_maxValue = maxValue;

			_range = _maxValue - _minValue;

			update(); // replaced setMaskSize( _maskSize );
			
		}

		/**
		 * Настройка размера ползунка. Указывается ширина или высота в зависимости от ориентации прокрутки.
		 * @param autoSize:Boolean - вкл./откл. автоматического изменения размера в зависимости от диапазона прокрутки и размера маски.
		 * 					По-умолчанию autoSize = true.
		 * @param thumbHeight:Number - если autoSize = false, можно задать фиксированный размер ползунка.
		 * 						Минимальный размер ползунка 5 px.
		 */
		public function setThumbAutoSize( autoSize:Boolean, thumbHeight:Number = 5 ):void
		{
			_thumbAutoSize = autoSize;
			super.getThumb().height = Math.max( minThumbHeight, thumbHeight );
			
			update(); // replaced setMaskSize( _maskSize );
		}

		public function get maskSize():Number
		{
			return _maskSize;
		}
		
		/**
		 * Размер маски. Указывается ширина или высота в зависимости от ориентации прокрутки.
		 * @param value:Number
		 */
		public function setMaskSize( value:Number ):void
		{
			_maskSize = value;

			
			// code from update();

			update();
		}

		/*==========================================================================
		 Обновляторы
		 ===========================================================================*/
		/**
		 * Обновление свойства целевого объекта, в зависимости от значения позиции.
		 */
		public function update():void
		{
			if ( _thumbAutoSize ) {
//				Log.traceText( "    set thumb height : " + (super.size * ( (_maskSize ? _maskSize : 1) / _range )) );
				super.getThumb().height = Math.max( minThumbHeight, super.size * ( (_maskSize ? _maskSize : 1) / _range ) );
//				Log.traceText( "    super.getThumb().height : " + super.getThumb().height );
			}

			/*/
			 if( _maskSize >= _range ) {
			 super.position = 0; //
			 } else {
			 //				updatePosition();
			 super.updateThumbPosition();
			 }
			 //*/
			if ( _maskSize < _range ) {
				super.updateThumbPosition();
			}
			//*/

			updateTargetPosition();
			checkThumbVisible();
		}
		
		private function updateTargetPosition():void
		{
			if ( !_scrollTarget || !_param ) return;


			var offsetValue:Number = 0;
			if ( _maskSize < _range ) {
				offsetValue = super.position * (_range - _maskSize) * (inverted ? -1 : -1);
			}
			_scrollTarget[_param] = _minValue + offsetValue;

			/*/
			 var deltaView:Number = Math.max( 0, _range - _maskSize );
			 _scrollTarget[_param] = _minValue + super.position * deltaView * (inverted ? -1 : -1);
			 /*/
//			_scrollTarget[_param] = _minValue + super.position * (_range - _maskSize) * (inverted ? -1 : -1);
			//*/
		}

		/**
		 * Проверка видимости ползунка. Если размер маски больше размера маскируемого объекта, то ползунок скрывается.
		 */
		private function checkThumbVisible():void
		{
			var vis:Boolean = ( _range + 2*overhang ) > _maskSize;

			if ( vis == super.getThumb().visible ) return;

			super.getThumb().visible = vis;
		}

		override public function kill():void
		{
			removeMouseControl();

			super.kill();

			_scrollTarget = null;
			_param = null;

		}

	}

}