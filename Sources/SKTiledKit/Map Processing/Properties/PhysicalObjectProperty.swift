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

public enum PhysicalObjectProperty : String, AutomaticallyMappableProperty,CaseIterable {
    public typealias TargetObjectType = SKPhysicsBody
    case physicsCategory, physicsCollisionMask, physicsContactMask, physicsPreciseCollisions
    case affectedByGravity, allowsRotation, isDynamic, mass, friction, restitution, linearDamping, angularDamping

    public var tiledPropertyName: String {
        switch self {
        default:
            return rawValue
        }
    }
    
    public var tiledDefaultValue: PropertyValue {
        return Self.defaults[self] ?? .error(type: "Unknown", value: "Error")
    }
    
    public var keyPath : PartialKeyPath<TargetObjectType> {
        switch self {
        case .physicsCategory:
            return \TargetObjectType.physicsCategory
        case .physicsCollisionMask:
            return \TargetObjectType.physicsCollisionMask
        case .physicsContactMask:
            return \TargetObjectType.physicsContactMask
        case .physicsPreciseCollisions:
            return \TargetObjectType.usesPreciseCollisionDetection
        case .affectedByGravity:
            return \TargetObjectType.affectedByGravity
        case .allowsRotation:
            return \TargetObjectType.allowsRotation
        case .isDynamic:
            return \TargetObjectType.isDynamic
        case .mass:
            return \TargetObjectType.mass
        case .friction:
            return \TargetObjectType.friction
        case .restitution:
            return \TargetObjectType.restitution
        case .linearDamping:
            return \TargetObjectType.linearDamping
        case .angularDamping:
            return \TargetObjectType.angularDamping
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
