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

internal extension SKShapeNode {
    var trackObjectId : Int {
        get {
            return userData?["trackObjectId"] as? Int ?? 0
        }
        set {
            guard let userData = userData else {
                SceneLoader.warn("No user data to set trackObjectId for camera to \(newValue)")
                return
            }
            userData["trackObjectId"] = newValue
        }
    }
}

public enum CameraProperty : String, AutomaticallyMappableProperty, CaseIterable {
    public typealias TargetObjectType = SKShapeNode
    
    case trackObject

    public var tiledPropertyName: String {
        return rawValue
    }
    
    public var tiledDefaultValue: PropertyValue {
        return .object(id: 0)
    }
    
    public var keyPath: PartialKeyPath<SKShapeNode> {
        switch  self {
        case .trackObject:
            return \SKShapeNode.trackObjectId
        }
    }
}
