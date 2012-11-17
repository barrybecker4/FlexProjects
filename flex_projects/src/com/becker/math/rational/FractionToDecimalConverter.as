package com.becker.math.rational {
   
import com.becker.common.Util;

/**
 * Convert from fraction to a decimal representation of a rational number.
 * We will simulate long division to determine at what point the the decimal
 * part starts to repeat. There are some limitations due to floating point precision,
 * but they are not as great as if we just try to devide the two numbers.
 * 
 * @author Barry Becker
 */
public class FractionToDecimalConverter {
        
    /**
     * Converts the specified fraction to an equivalent decimal form by doing long division.
     * @param	fraction the fraction to convert.
     * @return the same rational number represented as a repeating decimal.
     */
    public function convert(fraction:Fraction):Decimal {
            
        var wholePart:int = fraction.numerator / fraction.denominator;
        var numerator:int = fraction.numerator - wholePart * fraction.denominator;
        
        var result:Object = longDivision(numerator, fraction.denominator);
        
        var decimalPart:String = result.quotient.substring(0, result.firstRepeat);
        var repeatingPart:uint = parseInt(result.quotient.substring(result.firstRepeat));
        
        return new Decimal(wholePart, decimalPart, repeatingPart);
    }
    
    /**
     * Do long division in order to find where the infinitely repeating decimal part starts.
     * @param	numerator divident
     * @param	denominator divisor
     * @return an object containing the decimal quotient - part of which is the repeating decimal part.
     *   The repeating decimal part starts at the firstRepeat'th digit.
     */
    private function longDivision(numerator:int, denominator:int):Object {
        if (numerator > denominator) {
            throw Error("Numerator must be smaller than denominator");
        }
        
        var numer:String = "" + numerator;
        var quotient:String = "";
        var remainderRepeatIndex:int = -1;
        var lastRemainder:int = numerator;
        var remainders:Array = [numerator];
        
        do {
            quotient += getNextDigit(denominator, remainders);
            lastRemainder = remainders[remainders.length - 1];
            remainderRepeatIndex = remainders.indexOf(lastRemainder);
        } while (remainderRepeatIndex == remainders.length - 1);
        
        if (lastRemainder == 0) {
           quotient = quotient.substring(0, quotient.length - 1); 
        } 
      
        return {"quotient": quotient, "firstRepeat": remainderRepeatIndex};
    }
    
    private function getNextDigit(denominator:int, remainders:Array):int {
        
        var numerator:int = remainders[remainders.length-1] * 10;
        var q:int = numerator / denominator;
        remainders.push(numerator - q * denominator);
        return q;
    }
}
}