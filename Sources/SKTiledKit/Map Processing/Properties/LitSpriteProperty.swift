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

fileprivate extension SKSpriteNode {
    var litByMask : Int {
        get {
            return Int(bitPattern: UInt(lightingBitMask))
        }
        set {
            lightingBitMask = UInt32(bitPattern: Int32(newValue))
        }
        
    }
    var shadowedByMask : Int {
        get {
            return Int(bitPattern: UInt(shadowedBitMask))
        }
        set {
            shadowedBitMask = UInt32(bitPattern: Int32(newValue))
        }
        
    }
    var castsShadowsByMask : Int {
        get {
            return Int(bitPattern: UInt(shadowCastBitMask))
        }
        set {
            shadowCastBitMask = UInt32(bitPattern: Int32(newValue))
        }
        
    }
    
    var normalImage : URL? {
        get {
            return userData?["normalImage"] as? URL
        }
        set {
            guard let userData = userData else {
                SceneLoader.warn("No userData on sprite to store normalImage URL \(newValue?.path ?? "")")
                return
            }
            userData["normalImage"] = newValue
        }
    }
}

public enum LitSpriteProperty : String, AutomaticallyMappableProperty,CaseIterable {
    public typealias TargetObjectType = SKSpriteNode

    case litByMask, shadowedByMask, castsShadowsByMask, normalImage
    
    public var keyPath: PartialKeyPath<TargetObjectType> {
        switch self {
        
        case .litByMask:
            return \SKSpriteNode.lightingBitMask
        case .shadowedByMask:
            return \SKSpriteNode.shadowedBitMask
        case .castsShadowsByMask:
            return \SKSpriteNode.shadowCastBitMask
        case .normalImage:
            return \SKSpriteNode.normalTexture
        }
    }
    
    public var isMask: Bool {
        switch self {
        case .litByMask, .shadowedByMask, .castsShadowsByMask:
            return true
        case .normalImage:
            return false
        }
    }
    
    public var tiledPropertyName: String {
        return rawValue
    }
    
    public var tiledDefaultValue: PropertyValue {
        switch self {
        case .litByMask, .shadowedByMask, .castsShadowsByMask:
            return .int(0)
        case .normalImage:
            return .file(url: URL(fileURLWithPath: "normalImage.png"))
        }
    }
}
