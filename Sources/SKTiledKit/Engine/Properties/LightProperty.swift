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

fileprivate extension SKLightNode {
    var direction : Int {
        get {
            return Int(zRotation.degrees)
        }
        set {
            zRotation = newValue.cgFloatValue.radians
        }
    }
    
    var lightCategory : Int {
        get {
            return Int(bitPattern: UInt(categoryBitMask))
        }
        set {
            categoryBitMask = UInt32(bitPattern: Int32(newValue))
        }
    }
}

public enum LightProperty : String, BridgableProperty, CaseIterable {
    public typealias EngineObjectType = SKLightNode
    
    case lightCategory, ambientColor, lightColor, shadowColor, falloff, direction

    public var engineObjectProperty: PartialKeyPath<SKLightNode> {
        switch self {
        case .lightCategory:
            return \SKLightNode.lightCategory
        case .ambientColor:
            return \SKLightNode.ambientColor
        case .lightColor:
            return \SKLightNode.lightColor
        case .shadowColor:
            return \SKLightNode.shadowColor
        case .falloff:
            return \SKLightNode.falloff
        case .direction:
            return \SKLightNode.direction
        }
    }
    
    public var tiledDefault : PropertyValue {
        switch self {
        
        case .lightCategory:
            return .int(0)
        case .ambientColor, .lightColor:
            return .color(.white)
        case .shadowColor:
            return .color(.black)
        case .falloff:
            return 1.0
        case .direction:
            return 0
        }
    }
}
