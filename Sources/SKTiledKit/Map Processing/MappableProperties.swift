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

public protocol MappableProperty {
    var     tiledPropertyName : String                     {get}
    var     tiledDefaultValue : PropertyValue              {get}
}

public enum PhysicsProperty : String, MappableProperty, CaseIterable {
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
    
    public var keyPath : PartialKeyPath<SKPhysicsBody> {
        switch self {
        case .physicsCategory:
            return \SKPhysicsBody.categoryBitMask
        case .physicsCollisionMask:
            return \SKPhysicsBody.collisionBitMask
        case .physicsContactMask:
            return \SKPhysicsBody.contactTestBitMask
        case .physicsPreciseCollisions:
            return \SKPhysicsBody.usesPreciseCollisionDetection
        case .affectedByGravity:
            return \SKPhysicsBody.affectedByGravity
        case .allowsRotation:
            return \SKPhysicsBody.allowsRotation
        case .isDynamic:
            return \SKPhysicsBody.isDynamic
        case .mass:
            return \SKPhysicsBody.mass
        case .friction:
            return \SKPhysicsBody.friction
        case .restitution:
            return \SKPhysicsBody.restitution
        case .linearDamping:
            return \SKPhysicsBody.linearDamping
        case .angularDamping:
            return \SKPhysicsBody.angularDamping
        }
    }
    
    public func apply(to object:SKPhysicsBody, _ value:PropertyValue){
        switch self {
        case .physicsCategory, .physicsCollisionMask, .physicsContactMask:
            if let keyPath = keyPath as? ReferenceWritableKeyPath<SKPhysicsBody,UInt32>, case let PropertyValue.int(value) = value {

                object[keyPath: keyPath] = UInt32(bitPattern: Int32(value))
            }
        case .affectedByGravity, .isDynamic, .allowsRotation, .physicsPreciseCollisions:
            if let keyPath = keyPath as? ReferenceWritableKeyPath<SKPhysicsBody,Bool>, case let PropertyValue.bool(value) = value {

                object[keyPath: keyPath] = value
            }
        case .mass, .friction, .restitution, .linearDamping, .angularDamping:
            if let keyPath = keyPath as? ReferenceWritableKeyPath<SKPhysicsBody,CGFloat>, case let PropertyValue.double(value) = value {
                if case .mass = self, value < 0 {
                    return
                }

                object[keyPath: keyPath] = CGFloat(value)
            }
        }
    }

    private static var defaults : [PhysicsProperty : PropertyValue] = [
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
