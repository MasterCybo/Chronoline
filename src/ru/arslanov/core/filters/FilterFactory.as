package ru.arslanov.core.filters {
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * Коллекция базовых фильтров - FilterFactory
	 * @author Artem Arslanov
	 */
	public class FilterFactory {
		public static const DESATURATE_LIGHT:Array = [new ColorMatrixFilter ([0.3086, 0.6093999743461609, 0.0820000022649765, 0, 49.999996185302734, 0.3086, 0.6093999743461609, 0.0820000022649765, 0, 49.999996185302734, 0.3086, 0.6093999743461609, 0.0820000022649765, 0, 49.999996185302734, 0, 0, 0, 1, 0])];
		public static const DESATURATE_DARK:Array = [new ColorMatrixFilter ([0.3, 0.6, 0.1, 0.0, 0.0, 0.3, 0.6, 0.1, 0.0, 0.0, 0.3, 0.6, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0])];
		public static const SEPIA:Array = [new ColorMatrixFilter ([0.3930000066757202, 0.7689999938011169, 0.1889999955892563, 0, 0, 0.3490000069141388, 0.6859999895095825, 0.1679999977350235, 0, 0, 0.2720000147819519, 0.5339999794960022, 0.1309999972581863, 0, 0, 0, 0, 0, 1, 0])];
		
		static private var mtx:ColorMatrix;
		
		static public function brightness (value:Number):Array {
			mtx = new ColorMatrix ();
			mtx.adjustBrightness (value * 255 * 0.01);
			return [new ColorMatrixFilter (mtx)];
		}
		
		static public function contrast (value:Number):Array {
			mtx = new ColorMatrix ();
			mtx.adjustContrast (value);
			return [new ColorMatrixFilter (mtx)];
		}
		
		static public function saturation (value:Number):Array {
			mtx = new ColorMatrix ();
			mtx.adjustSaturation (value);
			return [new ColorMatrixFilter (mtx)];
		}
		
		static public function hue (value:Number):Array {
			mtx = new ColorMatrix ();
			mtx.adjustHue (value);
			return [new ColorMatrixFilter (mtx)];
		}
	}

}