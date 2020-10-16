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



public extension ObjectType {
    init<S:Sequence>(_ color:Color, with properties:S) where S.Element : TiledEngineBridgableProperty {
        self.init(color: color)
        
        
        for property in properties {
            self[property.tiledName] = property.tiledDefault
        }
    }
    
    func and<S:Sequence>(_ properties:S) -> ObjectType where S.Element : TiledEngineBridgableProperty {
        
        var newType = ObjectType(color: color)
        
        for property in self.allPropertyNames {
            newType[property] = self[property]
        }
        
        for property in properties {
            newType[property.tiledName] = property.tiledDefault
        }
        
        return newType
    }
}

public extension Sequence where Element : TiledEngineBridgableProperty {
    var tiledProperties : Properties {
        var results = Properties()
        
        for property in self {
            results[property.tiledName] = property.tiledDefault
        }
        
        return results
    }
}

#warning("API: Promote to TiledKit")
public extension Engine {
    
    static var enginePrefix : String {
        return "SK"
    }
    
    static var objectTypes : ObjectTypes {
        var engineTypes = ObjectTypes()
        
        engineTypes["\(enginePrefix)Camera"] = ObjectType(.darkGrey,with: CameraProperty.allCases)

        engineTypes["\(enginePrefix)Shape"] = ObjectType(.green,with: NodeProperty.allCases).and(ShapeProperty.allCases).and(PhysicalObjectProperty.allCases).and(LitSpriteProperty.allCases)

        engineTypes["\(enginePrefix)Light"] = ObjectType(.yellow, with: NodeProperty.allCases).and(LightProperty.allCases)

        engineTypes["\(enginePrefix)EdgeLoop"] = ObjectType(.white, with: NodeProperty.allCases).and(PhysicalObjectProperty.allCases)

        engineTypes["\(enginePrefix)Sprite"] = ObjectType(.blue,
                                                          with:
                 NodeProperty.allCases)
            .and(PhysicalObjectProperty.allCases)
            .and(LitSpriteProperty.allCases)

        return engineTypes
    }
}
