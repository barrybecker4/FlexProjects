package com.becker.math.rational {
import flash.errors.IllegalOperationError;
    
/**
 * Represents a rational number (i.e. a fraction)
 * @author Barry Becker
 */
public class Fraction {
    
    public var numerator:int;
    private var _denominator:int;
    
    /**
     * Constructor
     * @param numer integer numerator
     * @param denim integer denominator
     */
    public function Fraction(numer:int = 1, denom:int = 1) {
        numerator = numer;
        denominator = denom;
    }
    
    public function get denominator():int {
        return _denominator;
    }
    public function set denominator(d:int):void {
        if (d == 0) {
            throw new Error("Denominator cannot be 0!");
        }
        _denominator = d;
    }
    
    public function getAsDecimal():Decimal {
        return new FractionToDecimalConverter().convert(this);
    }
    
    public function toString():String {
        return numerator + "/" + denominator;
    }
    
    public function equals(otherFraction:Fraction):Boolean {
        return numerator == otherFraction.numerator && denominator == otherFraction.denominator;
    }
}
}