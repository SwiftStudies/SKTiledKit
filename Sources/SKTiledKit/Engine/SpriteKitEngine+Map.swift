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

extension SKScene : EngineMap {
}

public extension SpriteKitEngine {
    typealias MapType = SKScene

    static func make(engineMapForTiled map: Map) throws -> SKScene {
        let scene = SKScene(size: map.pixelSize.cgSize)

        scene.backgroundColor = map.backgroundColor?.skColor ?? SKColor.black
        
        return scene
    }
    
    static func postProcess(_ specializedMap: SKScene, for map: Map, from project: Project) throws -> SKScene {
        return specializedMap
    }
}
