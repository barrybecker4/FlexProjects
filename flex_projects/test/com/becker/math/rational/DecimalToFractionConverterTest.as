package com.becker.math.rational {
    
    import com.becker.common.BaseTest;
    import com.becker.expression.TreeSerializer;
    import com.becker.expression.TreeNode;
    import mx.controls.Alert;
    import flash.utils.getTimer;
    
    /**
     * @author Barry Becker
     */
    public class DecimalToFractionConverterTest extends BaseTest {
        
        /** instance under test */
        private var converter:DecimalToFractionConverter;
    
  
        public function run():String {
            
            converter = new DecimalToFractionConverter();
            return runPositiveTests();
        }
        
        public function runPositiveTests():String {
            
            var log:String = "\nnow running decimal to fraction converter tests...\n";
           
            for each (var testCase:Array in RationalConversionCases.CASES) {
                try {
                    log += testCase[1] +" : ";
                    var fractionResult:Fraction = converter.convert(testCase[1]);
                    if (fractionResult.equals(testCase[0])) {
                        log += " Success.";
                    } else {
                        log += " <b>Fail</b> Expected " + testCase[0] + " but got " + fractionResult;
                    }

                } catch (e:Error) {
                    log += "<b>Failed</b> for case="+ testCase[1] + " (expected "+testCase[0] +")  \n  " + e.message;
                }
                log += "\n";
            }
            return log;
        }
    }
}