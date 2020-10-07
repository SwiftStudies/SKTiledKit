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

public class EdgeLoopProcessor : ObjectPostProcessor {
        
    public func process(_ node: SKNode, for object: Object, in layer: Layer, and map: Map, from project: Project) throws -> SKNode {
        if let type = object.type, type == "SKEdgeLoop", let node = node as? SKShapeNode, let path = node.path {
            switch object.kind {
            case .polyline:
                node.physicsBody = SKPhysicsBody(edgeChainFrom: path)
            case .polygon, .ellipse, .rectangle:
                node.physicsBody = SKPhysicsBody(edgeLoopFrom: path)
            default:
                SceneLoader.warn("Ignoring SKEdgeLoop on \(object.name)[\(object.id)]. Object kind not supported \(object.kind)")
            }
        }
        return node
    }

}
