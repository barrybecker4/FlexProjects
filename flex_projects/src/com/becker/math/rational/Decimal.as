package com.becker.math.rational {
    
import com.becker.common.Util;
/**
 * Represents a rational number in decimal form.
 * @author Barry Becker
 */
public class Decimal {
     
    public var fixedWholePart:int;
    public var fixedDecimalPart:String;
    public var repeatingDecimalPart:int;
    
    
    /**
     * Constructor
     * @param	fixedWholePart part to the left of the decimal place. 0 if none.
     * @param	fixedDecimalPart part to the right of the decimal that does not repeat.
     *    Has to be a string to differentiate between "", "0", and "00", "00023", etc.
     * @param	repeatingDecimalPart part to the right of the fixed decimal 
     *          part that does repeat. 0 if none since an inifinite number of trailing 0's
     *          do not change the value.
     */
    public function Decimal(
        fixedWholePart:int = 1, fixedDecimalPart:String = "", repeatingDecimalPart:int = 0) {
            
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
    
    /**
     * @return decimal expansion of the rational in string form.
     */
    public function toString():String {
        var base:String = fixedWholePart + "." +  fixedDecimalPart;
        return  repeatingDecimalPart > 0 ? base + "(" + repeatingDecimalPart + "...)" : base;
    }
    
    public function equals(otherDeci:Decimal):Boolean {
        return fixedWholePart == otherDeci.fixedWholePart 
            && fixedDecimalPart == otherDeci.fixedDecimalPart
            && repeatingDecimalPart == otherDeci.repeatingDecimalPart;
    }
}
}
