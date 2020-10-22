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

internal extension SKNode {
    var userInteractionTarget : Int {
        get {
            return userData?[Interactable.actionTarget.rawValue] as? Int ?? 0
        }
        set {
            userData?[Interactable.actionTarget.rawValue] = newValue
        }
    }
    
    var interactionBeganActionKey : String {
        get {
            return userData?[Interactable.interactionBeganActionKey.rawValue] as? String ?? ""
        }
        set {
            userData?[Interactable.interactionBeganActionKey.rawValue] = newValue
        }
    }

    var interactionEndedActionKey : String {
        get {
            return userData?[Interactable.interactionEndedActionKey.rawValue] as? String ?? ""
        }
        set {
            userData?[Interactable.interactionEndedActionKey.rawValue] = newValue
        }
    }
}

public enum Interactable : String, CaseIterable, BridgableProperty {
    public typealias EngineObjectType = SKNode
    
    case userInteraction, interactionBeganActionKey, interactionEndedActionKey, actionTarget
    
    public var tiledDefault: PropertyValue {
        switch self {
        case .userInteraction:
            return false
        case .interactionBeganActionKey, .interactionEndedActionKey:
            return ""
        case .actionTarget:
            return .object(id: 0)
        }
    }
    
    public var engineObjectProperty: PartialKeyPath<SKNode>{
        switch self {
        case .userInteraction:
            return \EngineObjectType.isUserInteractionEnabled
        case .actionTarget:
            return \EngineObjectType.userInteractionTarget
        case .interactionBeganActionKey:
            return \EngineObjectType.interactionBeganActionKey
        case .interactionEndedActionKey:
            return \EngineObjectType.interactionEndedActionKey
        }
    }
}
