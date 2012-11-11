package com.becker.math.rational {
import flash.errors.IllegalOperationError;
import flash.events.Event;
 
/**
 * View model for holding all the parts of a rational number
 * and changing it from a repeating decimal to a fraction.
 * 
 * @author Barry Becker
 */
[Bindable]
public class RationalNumberModel {
    
    public static const FRACTION_UPDATED:String = "fractionUpdated";
    public static const DECIMAL_UPDATED:String = "decimalUpdated";
    
    private var _fixedDecimalPart:String;
    private var _repeatingPart:String;
    
    private var _numeratorPart:String;
    private var _denominatorPart:String;
    
    private var decimal:Decimal;
    private var fraction:Fraction;
    
    private var eventDispatcher:EventDispatcher;
  
   
    public function RationalNumberModel() {
        eventDispatcher = new EventDispatcher();
        
        _fixedDecimalPart = "1.";
        _repeatingPart = "0";
        _numeratorPart = "1";
        _denominatorPart = "1";
        
        decimal = new Decimal(1, 0, 0);
        fraction = new Fraction(1, 1);
    }
    
    /**
     * @param evtName either FRACTION_UPDATED or DECIMAL_UPDATED
     * @param handler function to call when the event has been recieved.
     */
    public function addListener(eventName:String, handler:Function):void {
        eventDispatcher.addEventListener(eventName, handler, false, 0, true);
    }
    
   
    public function get fixedDecimalPart():String {
        return _fixedDecimalPart;
    }
    public function set fixedDecimalPart(v:String):void {
        _fixedDecimalPart = v;
        // split into whole and decimal part
        var parts:Array = v.split('.');
        
        if (parts.length > 0) {
            decimal.fixedWholePart = parts[0];
        }
        if (parts.length > 1) {
            decimal.fixedDecimalPart = parts[1];
        }
        if (parts.length > 2) {
            throw new Error("Too many decimal points!");
        }
        
        updateFraction();
    }

    public function get repeatingPart():String {
        return _repeatingPart;
    }
    public function set repeatingPart(v:String):void {
        _repeatingPart = v;
        decimal.repeatingDecimalPart = parseInt(v);
        updateFraction();
    }

    public function get numeratorPart():String {
        return _numeratorPart;
    }
    public function set numeratorPart(v:String):void {
        _numeratorPart = v;
        fraction.numerator = parseInt(v);
        updateDecimal();
    }

    public function get denominatorPart():String {
        return _denominatorPart;
    }
    public function set denominatorPart(v:String):void {
        _denominatorPart = v;
        fraction.denominator = parseInt(v);
        updateDecimal();
    }
    
    private function updateFraction():void {
        
        fraction = decimal.getAsFraction();
        _numeratorPart = "" + fraction.numerator;
        _denominatorPart = "" + fraction.denominator;
        eventDispatcher.dispatchEvent(new Event(FRACTION_UPDATED));
    }
    
    private function updateDecimal():void {
        decimal = fraction.getAsDecimal();
        _fixedDecimalPart = decimal.fixedWholePart + "." + decimal.fixedDecimalPart;
        _repeatingPart = "" + decimal.repeatingDecimalPart;
        eventDispatcher.dispatchEvent(new Event(DECIMAL_UPDATED));
    }

}
}