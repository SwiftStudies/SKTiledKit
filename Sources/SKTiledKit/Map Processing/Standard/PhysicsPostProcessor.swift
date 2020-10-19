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

public struct PhysicsPropertiesPostProcessor : TiledKit.ObjectPostProcessor {
    public typealias EngineType = SpriteKitEngine
    
    let generic = BridgedPropertyProcessor<SKNode>(applies: PhysicalObjectProperty.allCases, to: [.anyObject, .objectLayer, .groupLayer])
    
    public func process(point: SKNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKNode {
        return try generic.process(point: point, from: object, for: map, from: project)
    }
    
    public func process(text: SKTKTextNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKTKTextNode {
        return try generic.process(text: text, from: object, for: map, from: project)
    }
    
    public func process(polygon shape: SKShapeNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKShapeNode {
        return try generic.process(polygon: shape, from: object, for: map, from: project)
    }
    
    public func process(polyline shape: SKShapeNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKShapeNode {
        return try generic.process(polyline: shape, from: object, for: map, from: project)
    }
    
    public func process(rectangle shape: SKShapeNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKShapeNode {
        return try generic.process(rectangle: shape, from: object, for: map, from: project)
    }
    
    public func process(ellipse shape: SKShapeNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKShapeNode {
        return try generic.process(ellipse: shape, from: object, for: map, from: project)
    }
    
    public func process(sprite: SKSpriteNode, from object: ObjectProtocol, for map: Map, from project: Project) throws -> SKSpriteNode {
        return try generic.process(sprite: sprite, from: object, for: map, from: project)
    }
}

//public struct PhysicsPropertiesPostProcessor : ObjectPostProcessor {
//    private let genericProcessor : PropertyPostProcessor<SKPhysicsBody>
//
//    public init(){
//        genericProcessor = PropertyPostProcessor<SKPhysicsBody>(for: nil, fromNodeWith: \SKNode.guaranteedPhysicsBody as KeyPath<SKNode, SKPhysicsBody>, with: PhysicalObjectProperty.allCases)
//    }
//
//    public func process(_ node: SKNode, of type: String?, with properties: Properties) throws -> SKNode {
//        return try genericProcessor.process(node, of: type, with: properties)
//    }
//
//    public func process(_ node: SKNode, for object: Object, in layer: Layer, and map: Map, from project: Project) throws -> SKNode {
//
//        return try genericProcessor.process(node, for: object, in: layer, and: map, from: project)
//
//    }
//
//
//}
