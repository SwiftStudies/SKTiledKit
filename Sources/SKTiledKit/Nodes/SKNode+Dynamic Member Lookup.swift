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

extension SKNode {
    subscript(dynamicMember member:String)->String? {
        guard let property = userData?[member] else {
            return nil
        }
        
        return property as? String
    }
    
    subscript(dynamicMember member:String)->Bool? {
        guard let property = userData?[member] else {
            return nil
        }
        
        return property as? Bool
    }
    
    subscript(dynamicMember member:String)->Int? {
        guard let property = userData?[member] else {
            return nil
        }
        
        return property as? Int
    }

    subscript(dynamicMember member:String)->Double? {
        guard let property = userData?[member] else {
            return nil
        }
        
        return property as? Double
    }

    
    subscript(dynamicMember member:String)->SKColor? {
        guard let property = userData?[member] else {
            return nil
        }
        
        return property as? SKColor
    }

}
