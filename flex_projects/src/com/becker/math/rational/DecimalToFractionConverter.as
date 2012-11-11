package com.becker.math.rational {
   
import com.becker.common.Util;

/**
 * Convert from a decimal to fraction representation of a rational number.
 * 
 * @author Barry Becker
 */
public class DecimalToFractionConverter {
    
    public function convert(decimal:Decimal):Fraction {
        
        var m:int = decimal.fixedDecimalPart.length;
        var n:int = getNumDigits(decimal.repeatingDecimalPart);
        
        var scaleM:int = Math.pow(10, m);
        var scaleN:int = Math.pow(10, n);
        
        var numerator:Number = 
            Number(decimal.fixedWholePart) + Number(decimal.fixedDecimalPart) / scaleM;
        var denominator:Number = 1;
        
        if (n > 0) {
            numerator = scaleN * numerator + Number(decimal.repeatingDecimalPart) / scaleM - numerator;
            denominator = scaleN - 1;
        }
        
        var intNumerator:int = numerator * scaleM;
        var intDenominator:int = denominator * scaleM;
        
        var gcf:int = Util.greatestCommonFactor(intNumerator, intDenominator);
         
        return new Fraction(intNumerator/gcf, intDenominator/gcf);
    }
    
    private function getNumDigits(num:int):int {
        return (num == 0) ? 0 : Util.log10(Number(num)) + 1;
    }
}
}