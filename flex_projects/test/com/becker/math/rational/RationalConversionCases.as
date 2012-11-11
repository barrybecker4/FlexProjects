package com.becker.math.rational {
	/**
     * Test cases for converting from fraction to decimal and then back again.\
     * 
     * @author Barry Becker
     */
    public class RationalConversionCases {
        
        public static const CASES:Array = [
            [new Fraction(1, 2), new Decimal(0, 5, 0)],
            [new Fraction(1, 1), new Decimal(1, 0, 0)],
            [new Fraction(2, 1), new Decimal(2, 0, 0)],
            [new Fraction(2, 2), new Decimal(1, 0, 0)],
            [new Fraction(1, 3), new Decimal(0, 0, 3)]
        ];
        
    }

}