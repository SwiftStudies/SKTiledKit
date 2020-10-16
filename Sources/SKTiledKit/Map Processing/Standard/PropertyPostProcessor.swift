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


#warning("ACTION: Delete file")
public struct PropertyPostProcessor<TargetObjectType> : ObjectPostProcessor {

    private struct PropertyWrapper : AutomaticallyMappableProperty {
        
        var keyPath: PartialKeyPath<TargetObjectType>
        
        var tiledPropertyName: String
        
        var tiledDefaultValue: PropertyValue
        
        init<AAMP:AutomaticallyMappableProperty>(_ wrap:AAMP) where AAMP.TargetObjectType == TargetObjectType {
            keyPath = wrap.keyPath
            tiledPropertyName = wrap.tiledPropertyName
            tiledDefaultValue = wrap.tiledDefaultValue
        }
        
    }
    
    private let applicableObjectTypeName : String?
    private let properties : [PropertyWrapper]
    private let keyPath : KeyPath<SKNode,TargetObjectType>?
    
    public init<AMP:AutomaticallyMappableProperty>(for objectTypeName:String? = nil, fromNodeWith keypath:KeyPath<SKNode,TargetObjectType>? = nil, with properties:[AMP]...) where AMP.TargetObjectType == TargetObjectType {
        applicableObjectTypeName = objectTypeName
        var finalProperties = [PropertyWrapper]()
        for propertySet in properties {
            finalProperties.append(
                contentsOf: propertySet.map({PropertyWrapper($0)}))
        }
        self.properties = finalProperties
        self.keyPath = keypath
    }
    
    public func process(_ node:SKNode, of type:String?, with properties:Properties) throws -> SKNode {
        //If the passed object is not of the applicable type, just skip
        if let applicableObjectTypeName = applicableObjectTypeName {
            guard let type = type, type == applicableObjectTypeName else {
                return node
            }
        }
        
        //Don't bother if the object has none of the expected properties
        guard properties.hasProperty(in: self.properties) else {
            return node
        }
        
        //Validate that the supplied node is of the correct type
        let targetObject : TargetObjectType
        if let keyPath = keyPath {
            targetObject = node[keyPath: keyPath]
        } else {
            guard let targetNode = node as? TargetObjectType else {
                if let applicableObjectTypeName = applicableObjectTypeName {
                    SceneLoader.warn("\(applicableObjectTypeName) expected a node of type \(TargetObjectType.self), but node was \(Swift.type(of: node)). Ignored")
                }
                return node
            }
            targetObject = targetNode
        }
        
        for property in self.properties {
            if let value = properties[property.tiledPropertyName] {
                property.apply(to: targetObject, value)
            }
        }
        
        return node
    }
    
    public func process(_ node: SKNode, for object: Object, in layer: Layer, and map: Map, from project: Project) throws -> SKNode {
        
        return try process(node, of: object.type, with: object.properties)

    }
    
    
}
