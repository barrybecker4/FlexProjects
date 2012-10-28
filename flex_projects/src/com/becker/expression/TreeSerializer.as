package com.becker.expression {
    
    /**
     * Turns a tree into a string via in order traversal.
     * Implements visitor pattern
     * 
     * @author Barry Becker
     */
    public class TreeSerializer {
        
        private var serialized:String;
        
        
        public function serialize(node:TreeNode):String {
            serialized = "";
            if (node) {
                serialized = traverse(node);
            }
            return serialized? serialized : "Invalid";
        }
        
        /** processing for inner nodes */
        private function traverse(node:TreeNode):String {

            var text:String = "";
            if (node.children.length == 2) {
                text += (node.hasParens ? "(":"") + traverse(node.children[0]);
                text += " " + node.data + " ";
                text += traverse(node.children[1]) + (node.hasParens ? ")":"");
            }
            else {
                text += node.data;
            }
            return text;
        }
    }

}