package com.becker.common {
	/**
     * Abstract base class for all tests
     * 
     * @author Barry Becker
     */
    public class BaseTest {
        
        public function BaseTest() {
        }
        
        protected function assertEquals(msg:String, expected:String, actual:String):void {
            if (expected != actual) {
                throw new Error(msg + " expected :" + expected +" but got :" + actual);
            }
        }
        
    }

}