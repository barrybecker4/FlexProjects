package com.becker.math.rational {
	/**
     * Test cases for converting from fraction to decimal and then back again.\
     * 
     * @author Barry Becker
     */
    public class RationalConversionCases {
        
        public static const CASES:Array = [
            [new Fraction(1, 2), new Decimal(0, "5", 0)],
            [new Fraction(1, 1), new Decimal(1, "", 0)],
            [new Fraction(2, 1), new Decimal(2, "", 0)],
            [new Fraction(1, 3), new Decimal(0, "", 3)],
            [new Fraction(1, 6), new Decimal(0, "1", 6)],
            [new Fraction(1, 7), new Decimal(0, "", 142857)],
            [new Fraction(11, 7), new Decimal(1, "", 571428)],
            [new Fraction(20, 3), new Decimal(6, "", 6)],
            [new Fraction(101, 4), new Decimal(25, "25", 0)],
            [new Fraction(101, 8), new Decimal(12, "625", 0)],
            [new Fraction(101, 9), new Decimal(11, "", 2)],
            [new Fraction(101, 11), new Decimal(9, "", 18)],
            [new Fraction(101, 13), new Decimal(7, "", 769230)],
            [new Fraction(1, 90), new Decimal(0, "0", 1)],
            [new Fraction(67, 600), new Decimal(0, "111", 6)],
            [new Fraction(67, 60000), new Decimal(0, "00111", 6)],
            [new Fraction(60067, 60000), new Decimal(1, "00111", 6)],  // fails decimal to fraction
            [new Fraction(67, 2), new Decimal(33, "5", 0)],
            [new Fraction(67, 13), new Decimal(5, "", 153846)],
            //[new Fraction(63, 17), new Decimal(3, "", 70588235294117647)],  round off error
            [new Fraction(61, 17), new Decimal(3, "", 5882352941176470)],  // fails decimal to fraction
            [new Fraction(101, 17), new Decimal(5, "", 9411764705882352)], // fails decimal to fraction

            // There are 112 digits in the repeating part of this decimal so we cannot represent it with an int or Number.
            //[new Fraction(355, 113), new Decimal(3, "25", 1415929203539823008849557522123893805309734513274336283185840707964601769)]  
        ];
    }
}