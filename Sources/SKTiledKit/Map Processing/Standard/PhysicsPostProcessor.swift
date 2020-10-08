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

fileprivate extension SKNode {
    var guaranteedPhysicsBody : SKPhysicsBody {
        if let physicsBody = physicsBody {
            return physicsBody
        }
        SceneLoader.warn("Attempting to apply physical property to a \(type(of: self)) with no physicsBody")
        return SKPhysicsBody()
    }
}

public struct PhysicsPropertiesPostProcessor : ObjectPostProcessor {

    
    
    private let genericProcessor : PropertyPostProcessor<SKPhysicsBody>
    
    public init(){
        genericProcessor = PropertyPostProcessor<SKPhysicsBody>(for: nil, fromNodeWith: \SKNode.guaranteedPhysicsBody as KeyPath<SKNode, SKPhysicsBody>, with: PhysicalObjectProperty.allCases)
    }
    
    public func process(_ node: SKNode, of type: String?, with properties: Properties) throws -> SKNode {
        return try genericProcessor.process(node, of: type, with: properties)
    }
    
    public func process(_ node: SKNode, for object: Object, in layer: Layer, and map: Map, from project: Project) throws -> SKNode {
        
        return try genericProcessor.process(node, for: object, in: layer, and: map, from: project)

    }
    
    
}
