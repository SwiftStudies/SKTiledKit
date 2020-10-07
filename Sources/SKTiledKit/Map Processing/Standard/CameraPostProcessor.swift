//    Copyright 2020 Swift Studies
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

import TiledKit
import SpriteKit

public class CameraProcessor : ObjectPostProcessor, MapPostProcessor {
    var frame : CGRect? = nil
    var cameraShape : SKShapeNode? = nil
    var trackId : Int? = nil
    
    public init(){
        
    }
    
    public func process(_ node: SKNode, for object: Object, in layer: Layer, and map: Map, from project: Project) throws -> SKNode {
        guard object.type ?? "" == "SKCamera" else {
            return node
        }

        if let value = object.properties["trackObject"], case let PropertyValue.object(id: trackId) = value {
            self.trackId = trackId
        }
        
        guard let cameraShape = node as? SKShapeNode else {
            return node
        }
        
        self.cameraShape = cameraShape
        
        frame = cameraShape.calculateAccumulatedFrame()
        
        print("Camera node is in scene \(node.scene != nil)")
        
        return node
    }
    
    public func process(_ scene: SKScene, for map: Map, from project: Project) throws -> SKScene {
        guard let frame = frame, let cameraShape = cameraShape else {
            return scene
        }
        
        scene.size = frame.size
        
        let cameraNode = SKCameraNode()

        cameraNode.position = cameraShape.position
        scene.addChild(cameraNode)
        scene.camera = cameraNode
        
        cameraShape.removeFromParent()
        
        guard let trackId = trackId else {
            return scene
        }
        
        if let trackedNode = scene.child(withTiledObject: trackId) {
            cameraNode.constraints = [ SKConstraint.distance(SKRange(upperLimit: 0), to: trackedNode) ]
        }
                
        return scene
    }
}
