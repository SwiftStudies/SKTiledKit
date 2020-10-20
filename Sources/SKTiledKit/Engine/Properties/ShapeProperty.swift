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

public enum ShapeProperty : String, BridgableProperty, CaseIterable {
    public typealias EngineObjectType = SKShapeNode
    
    case fillColor, strokeColor
    
    public var engineObjectProperty : PartialKeyPath<SKShapeNode> {
        switch self {
        case .fillColor:
            return \EngineObjectType.fillColor
        case .strokeColor:
            return \EngineObjectType.strokeColor
        }
    }
    
    public var tiledDefault : PropertyValue {
        switch self {
        case .fillColor:
            return .color(.clear)
        case .strokeColor:
            return .color(.white)
        }
    }
    
    
}
