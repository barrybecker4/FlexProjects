package  com.becker.animation.box2d {
    
import Box2D.Collision.*;
import Box2D.Collision.Shapes.*;
import Box2D.Common.Math.*;
import Box2D.Dynamics.*;

import com.becker.animation.box2d.simulations.BridgeSimulation;
import com.becker.animation.box2d.simulations.HelloWorldSimulation;
import com.becker.animation.box2d.simulations.RagDollSimulation;
import com.becker.animation.box2d.simulations.TheoJansenSimulation;

import mx.core.UIComponent;

/**
 * A collection of avaialble simulations to choose from.
 * 
 * @author Barry Becker
 */
public class AvailableSimulations {
    
    
    /** some different demos to select from */
     public static const AVAILABLE_SIMULATIONS:Array = [
           "Hello World", 
           "Rag Doll", 
           "Bridge", 
           "Theo Jansen Spider" 
     ]; 
    
    /**
     * @param the name of a class that implements Simulation
     * @return the simulation instance corresponding to the name.
     */
    public function getSimulation(simulationName:String):Simulation {
    
        var simulation:Simulation;

        switch (simulationName) {
            case AVAILABLE_SIMULATIONS[0]: 
                simulation = new HelloWorldSimulation(); break;
            case AVAILABLE_SIMULATIONS[1]: 
                simulation = new RagDollSimulation(); break;
            case AVAILABLE_SIMULATIONS[2]: 
                simulation = new BridgeSimulation(); break;
            case AVAILABLE_SIMULATIONS[3]: 
                simulation = new TheoJansenSimulation(); break;
            default: throw new Error("Unexpected sim :" + simulationName);
        }
        
        return simulation;
    }
    
}
}