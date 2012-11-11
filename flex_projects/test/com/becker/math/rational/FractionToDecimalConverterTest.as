package com.becker.math.rational {
    
    import com.becker.common.BaseTest;
    import com.becker.expression.TreeSerializer;
    import com.becker.expression.TreeNode;
    import mx.controls.Alert;
    import flash.utils.getTimer;
    
    /**
     * @author Barry Becker
     */
    public class FractionToDecimalConverterTest extends BaseTest {
        
        /** instance under test */
        private var converter:FractionToDecimalConverter;
    
  
        public function run():String {
            
            converter = new FractionToDecimalConverter();
            return runPositiveTests();
        }
        
        public function runPositiveTests():String {
            
            var log:String = "\nnow running fraction to decimal converter tests...\n";
           
            for each (var testCase:Array in RationalConversionCases.CASES) {
                try {
                    log += testCase[0] +" : ";
                    var decimalResult:Decimal = converter.convert(testCase[0]);
                    if (decimalResult.equals(testCase[1])) {
                        log += " Success.";
                    } else {
                        log += " <b>Fail</b> Expected " + testCase[1] + " but got " + decimalResult;
                    }

                } catch (e:Error) {
                    log += "Failed for case="+ testCase[0] + " (expected "+testCase[1] +")  \n  " + e.message;
                }
                log += "\n";
            }
            return log;
        }
    }
}