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

@dynamicMemberLookup
public class SKTKNode : SKNode {
    
}

extension SKNode {
    func apply(propertiesFrom object:Propertied){
        if userData == nil {
            userData = NSMutableDictionary()
        }
        
        for property in object.properties {
            switch property.value {
            
            case .string(let value):
                userData?.setValue(value, forKey: property.key)
            case .bool(let value):
                userData?.setValue(value, forKey: property.key)
            case .int(let value):
                userData?.setValue(value, forKey: property.key)
            case .double(let value):
                userData?.setValue(value, forKey: property.key)
            case .file(url: let url):
                userData?.setValue(url, forKey: property.key)
            case .color(color: let color):
                userData?.setValue(color.skColor, forKey: property.key)
            case .object(id: let id):
                #warning("Should actually go an find the object")
                userData?.setValue(id, forKey: property.key)
            case .error(type: _, value: _):
                break
            }
        }
    }
}
