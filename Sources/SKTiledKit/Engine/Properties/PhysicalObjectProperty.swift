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

fileprivate extension SKPhysicsBody {
    var physicsCategory : Int {
        get {
            return Int(bitPattern: UInt(categoryBitMask))
        }
        set {
            categoryBitMask = UInt32(bitPattern: Int32(newValue))
        }
    }
    
    var  physicsCollisionMask : Int {
        get {
            return Int(bitPattern: UInt(collisionBitMask))
        }
        set {
            collisionBitMask = UInt32(bitPattern: Int32(newValue))
        }
    }
    
    var physicsContactMask : Int {
        get {
            return Int(bitPattern: UInt(contactTestBitMask))
        }
        set {
            contactTestBitMask = UInt32(bitPattern: Int32(newValue))
        }
    }
}

public extension SKNode {
    var guaranteedPhysicsBody : SKPhysicsBody {
        get {
            if let physicsBody = physicsBody {
                return physicsBody
            }

            SceneLoader.warn("Attempting to apply physical property to a \(type(of: self)) with no physicsBody")

            physicsBody = SKPhysicsBody()
            return physicsBody!
        }
    }
}

public enum PhysicalObjectProperty : String, TiledEngineBridgableProperty, CaseIterable {
    public typealias EngineObjectType = SKNode
    
    case physicsCategory, physicsCollisionMask, physicsContactMask, physicsPreciseCollisions
    case affectedByGravity, allowsRotation, isDynamic, mass, friction, restitution, linearDamping, angularDamping
    
    public var tiledDefault: PropertyValue {
        return Self.defaults[self] ?? .error(type: "Unknown", value: "Error")
    }
    
    public var engineObjectProperty : PartialKeyPath<EngineObjectType> {
        switch self {
        case .physicsCategory:
            return \EngineObjectType.guaranteedPhysicsBody.physicsCategory
        case .physicsCollisionMask:
            return \EngineObjectType.guaranteedPhysicsBody.physicsCollisionMask
        case .physicsContactMask:
            return \EngineObjectType.guaranteedPhysicsBody.physicsContactMask
        case .physicsPreciseCollisions:
            return \EngineObjectType.guaranteedPhysicsBody.usesPreciseCollisionDetection
        case .affectedByGravity:
            return \EngineObjectType.guaranteedPhysicsBody.affectedByGravity
        case .allowsRotation:
            return \EngineObjectType.guaranteedPhysicsBody.allowsRotation
        case .isDynamic:
            return \EngineObjectType.guaranteedPhysicsBody.isDynamic
        case .mass:
            return \EngineObjectType.guaranteedPhysicsBody.mass
        case .friction:
            return \EngineObjectType.guaranteedPhysicsBody.friction
        case .restitution:
            return \EngineObjectType.guaranteedPhysicsBody.restitution
        case .linearDamping:
            return \EngineObjectType.guaranteedPhysicsBody.linearDamping
        case .angularDamping:
            return \EngineObjectType.guaranteedPhysicsBody.angularDamping
        }
    }

    private static var defaults : [PhysicalObjectProperty : PropertyValue] = [
        .physicsCategory : 0,
        .physicsContactMask : 0,
        .physicsCollisionMask : 0,
        .physicsPreciseCollisions : false,
        .affectedByGravity : true,
        .allowsRotation : false,
        .isDynamic : false,
        .mass : -1.0,
        .friction : 0.2,
        .restitution : 0.2,
        .linearDamping : 0.1,
        .angularDamping : 0.1,
    ]
}
