package com.becker.math.rational {
   
import com.becker.common.Util;

/**
 * Convert from fraction to a decimal representation of a rational number.
 * 
 * @author Barry Becker
 */
public class FractionToDecimalConverter {
   
        
    public function convert(fraction:Fraction):Decimal {
            
        var wholePart:int = fraction.numerator / fraction.denominator;
        var decimalPart:Number =  (Number(fraction.numerator) / Number(fraction.denominator) - wholePart);
        
        var deciString:String = "" + decimalPart;
        
        // march thru until find repeating pattern
        var repeatingPattern:String = findRepeatingPattern(deciString);
        
        return new Decimal(wholePart, "" + decimalPart, 0);
    }
        
    private function findRepeatingPattern(deciString:String):String {
        return "foo";
    }
}
}