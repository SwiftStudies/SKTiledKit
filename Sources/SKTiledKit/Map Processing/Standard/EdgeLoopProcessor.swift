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

public class EdgeLoopProcessor : TiledKit.ObjectPostProcessor {
    public typealias EngineType = SpriteKitEngine
        
    public func process(_ point: EngineType.PointObjectType, from object: ObjectProtocol, for map: Map, from project: Project) throws -> EngineType.PointObjectType {
        SceneLoader.warn("Ignoring SKEdgeLoop on \(object.name)[\(object.id)]. Object type not supported \(object.tiledType)")
        return point
    }
    
    public func process(_ sprite: EngineType.SpriteType, from object: ObjectProtocol, for map: Map, from project: Project) throws -> EngineType.SpriteType {
        SceneLoader.warn("Ignoring SKEdgeLoop on \(object.name)[\(object.id)]. Object type not supported \(object.tiledType)")
        return sprite
    }
    
    public func process(_ text: EngineType.TextObjectType, from object: ObjectProtocol, for map: Map, from project: Project) throws -> EngineType.TextObjectType {
        SceneLoader.warn("Ignoring SKEdgeLoop on \(object.name)[\(object.id)]. Object type not supported \(object.tiledType)")
        return text
    }
    
    public func process(_ shape: EngineType.PolylineObjectType, from object: ObjectProtocol, for map: Map, from project: Project) throws -> EngineType.PolylineObjectType {
        
        if object.tiledType == .polylineObject {
            shape.physicsBody = SKPhysicsBody(edgeChainFrom: shape.path!)
        } else if [.polygonObject, .rectangleObject, .ellipseObject].contains(object.tiledType) {
            shape.physicsBody = SKPhysicsBody(edgeLoopFrom: shape.path!)
        } else {
            SceneLoader.warn("Ignoring SKEdgeLoop on \(object.name)[\(object.id)]. Object type not supported \(object.tiledType)")
        }
        
        return shape
    }
}
