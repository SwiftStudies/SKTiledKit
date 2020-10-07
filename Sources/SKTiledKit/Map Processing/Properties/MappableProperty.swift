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

public protocol MappableProperty  {
    var     tiledPropertyName : String                     {get}
    var     tiledDefaultValue : PropertyValue              {get}
}


public protocol AutomaticallyMappableProperty : MappableProperty {
    associatedtype TargetObjectType
    
    var keyPath : PartialKeyPath<TargetObjectType> {get}
}

public extension AutomaticallyMappableProperty {
    
    func apply(to object:TargetObjectType, _ value:PropertyValue){
        
        switch value {
        case .string(let value):
            if let keyPath = keyPath as? ReferenceWritableKeyPath<TargetObjectType,String> {
                object[keyPath: keyPath] = value
            } 
        case .bool(let value):
            if let keyPath = keyPath as? ReferenceWritableKeyPath<TargetObjectType,Bool> {
                object[keyPath: keyPath] = value
            }
        case .int(let value):
            if let keyPath = keyPath as? ReferenceWritableKeyPath<TargetObjectType,Int> {
                object[keyPath: keyPath] = value
            }
        case .double(let value):
            if let keyPath = keyPath as? ReferenceWritableKeyPath<TargetObjectType,CGFloat> {
                object[keyPath: keyPath] = value.cgFloatValue
            }
        case .file(let url):
            if let keyPath = keyPath as? ReferenceWritableKeyPath<TargetObjectType,URL> {
                object[keyPath: keyPath] = url
            }
        case .color(let color):
            if let keyPath = keyPath as? ReferenceWritableKeyPath<TargetObjectType,SKColor> {
                object[keyPath: keyPath] = color.skColor
            }
        case .object(let id):
            if let keyPath = keyPath as? ReferenceWritableKeyPath<TargetObjectType,Int> {
                object[keyPath: keyPath] = id
            }
        case .error(let type, _):
            SceneLoader.warn("Do not know how to apply \(type) property to \(Swift.type(of:object)).\(keyPath). Ignoring.")
        }
    }
}
