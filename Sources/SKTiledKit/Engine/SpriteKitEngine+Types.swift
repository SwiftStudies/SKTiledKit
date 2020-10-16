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
}

extension SKNode : EngineObject, EngineLayerContainer, EngineObjectContainer {
    public typealias EngineType = SpriteKitEngine
    
    public func add(child layer: SKNode) {
        addChild(layer)
    }
        
    public func add(child shape: SKShapeNode) {
        addChild(shape)
    }
    
    public func add(child sprite: SKSpriteNode) {
        addChild(sprite)
    }
    
    public func add(child text: SKTKTextNode) {
        addChild(text)
    }

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

