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

import SpriteKit
import TiledKit

extension SKTexture : EngineTexture {
    public typealias EngineType = SpriteKitEngine

    public func newInstance() -> Self {
        return self
    }    
}

extension SKNode : EngineObject, EngineLayerContainer, EngineObjectContainer {
    public func add(layer: SKNode) {
        addChild(layer)
    }
    
    
    public func add(sprite: SKSpriteNode) {
        addChild(sprite)
    }
        
    public func add(point: SKNode) {
        addChild(point)
    }
    
    public func add(rectangle: SKShapeNode) {
        addChild(rectangle)
    }
    
    public func add(ellipse: SKShapeNode) {
        addChild(ellipse)
    }
    
    public func add(text: SKTKTextNode) {
        addChild(text)
    }
    
    public func add(polyline: SKShapeNode) {
        addChild(polyline)
    }
    
    public func add(polygon: SKShapeNode) {
        addChild(polygon)
    }
    
    
    public typealias EngineType = SpriteKitEngine
    
    
}

extension SKSpriteNode : DeepCopyable {
    public func deepCopy() -> Self {
        
        let initialCopy = copy() as! Self
        
        if let originalBody = physicsBody {
            initialCopy.physicsBody = (originalBody.copy() as! SKPhysicsBody)
        }
    
        return initialCopy
    }
}

