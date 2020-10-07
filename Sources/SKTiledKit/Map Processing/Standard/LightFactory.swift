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

public struct LightFactory : ObjectFactory {
    public func make(nodeFor object: Object, in layer: Layer, and map: Map, from project: Project) throws -> SKNode? {
        guard let type = object.type, type == "SKLight" else {
            return nil
        }
        if case Object.Kind.point = object.kind {
            return SKLightNode()
        } else {
            SceneLoader.warn("Object \(object.name.isEmpty ? "\(object.id)" : object.name) is an SKLight, but is not a Point object. SKLight can only be applied to Tiled Point objects.")
            return nil
        }
    }
    
    
}
