package com.becker.expression {
    
    import com.becker.common.BaseTest;
    import com.becker.expression.TreeSerializer;
    import com.becker.expression.TreeNode;
    import mx.controls.Alert;
    import flash.utils.getTimer;
    
    /**
     * @author Barry Becker
     */
    public class ExpressionEvaluatorTest extends BaseTest {
        
        /** instance under test */
        private var evaluator:ExpressionEvaluator;
    
        private static const TEST_X_VALUES:Array = 
            [1.0, 0.1, -0.1, 0, 10.0, 23.2323, 100.0];
       
        public function run():String {
            
            return runPositiveTests();
        }
        
        public function runPositiveTests():String {
            
            var log:String = "\nnow running evaluator tests...\n";
            var root:TreeNode;
            var startTime:Number = getTimer();
            
            for each (var testCase:String in ExpressionCases.CASES) {
                try {
                    var exp:Expression = new Expression(testCase);
                    evaluator = new ExpressionEvaluator(exp);
                    log += testCase +" : ";
                    for each (var x:Number in TEST_X_VALUES) {
                        log += evaluator.evaluate(x) + " ";
                    }
                } catch (e:Error) {
                    log += "Failed for case="+ testCase + " when x=1.0  \n  " + e.message;
                }
                log += "\n";
            }
            var elapsed:Number = 0.001 * (getTimer() - startTime);
            log += "Evaluation tests finished in " + elapsed + " seconds.";
            return log;
        }
        
    }
}