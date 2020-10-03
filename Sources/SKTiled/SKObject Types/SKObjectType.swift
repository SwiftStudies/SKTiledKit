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


import Foundation
import TiledKit

struct SKObjectType {
    var color:Color
    var name : String
    var properties = [String:SKProperty]()
    
    init(_ name:String, color:Color, inherits from:[SKObjectType]=[]){
        self.name = from.reduce("", { (classPrefix, subClass) -> String in
            return classPrefix+subClass.name
        })+name
        self.color = color
        properties = inheritsFrom(from).properties
    }

    init(_ name:String, color:Color, inherits from:SKObjectType...){
        self.init(name, color: color, inherits: from)
    }

    private func inheritsFrom(_ parents:SKObjectType...)->SKObjectType {
        return inheritsFrom(parents)
    }

    private func inheritsFrom(_ parents:[SKObjectType])->SKObjectType {
        var fresh = self
        for parent in parents {
            for property in parent.properties.values {
                fresh.properties[property.propertyName] = property
            }
        }

        return fresh
    }
    
    func withProperties(_ properties:SKProperty...)->SKObjectType {
        return withProperties(properties)
    }
    
    func withProperties(_ properties:[SKProperty])->SKObjectType {
        var fresh = self
        
        for property in properties {
            fresh.properties[property.propertyName] = property
        }
        
        return fresh
    }
    
    var objectType : ObjectType {
        var objectType = ObjectType(color: color)
        
        for property in properties {
            objectType[property.key] = property.value.propertyValue
        }
        
        return objectType
    }
}
