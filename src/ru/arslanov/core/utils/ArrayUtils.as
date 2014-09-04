package ru.arslanov.core.utils {
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ArrayUtils {
		
		static public function randomValue( arrayOrVector:* ):* {
			return arrayOrVector[ Math.round( Math.random() * ( arrayOrVector.length - 1 ) ) ];
		}
	}

}