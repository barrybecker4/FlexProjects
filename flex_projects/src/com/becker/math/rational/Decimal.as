package com.becker.math.rational {
    
import com.becker.common.Util;
/**
 * Represents a rational number in decimal form.
 * @author Barry Becker
 */
public class Decimal {
    
    public var fixedWholePart:int;
    public var fixedDecimalPart:int;
    public var repeatingDecimalPart:int;
    
    /**
     * Constructor
     * @param	fixedWholePart part to the left of the decimal place
     * @param	fixedDecimalPart part to the right of the decimal that does not repeat.
     * @param	repeatingDecimalPart part to the right of the fixed decimal 
     *          part that does repeat.
     */
    public function Decimal(
        fixedWholePart:int = 1, fixedDecimalPart:int = 0, repeatingDecimalPart:int = 0) {
            
        this.fixedWholePart = fixedWholePart;
        this.fixedDecimalPart = fixedDecimalPart;
        this.repeatingDecimalPart = repeatingDecimalPart;     
    }
    
    public function getAsFraction():Fraction {
        
        return new DecimalToFractionConverter().convert(this);
        /*
        var exp:int = Util.log10(Number(fixedDecimalPart)) + 1;
        var factor:int = Math.pow(10, exp);
        var denom:int = factor;
        return new Fraction(fixedWholePart * factor + fixedDecimalPart, factor);
        */
    }
    
    public function toString():String {
        return fixedWholePart + "." + fixedDecimalPart + repeatingDecimalPart;
    }
    
    public function equals(otherDeci:Decimal):Boolean {
        return fixedWholePart == otherDeci.fixedWholePart 
            && fixedDecimalPart == otherDeci.fixedDecimalPart
            && repeatingDecimalPart == otherDeci.repeatingDecimalPart;
    }
}
}
