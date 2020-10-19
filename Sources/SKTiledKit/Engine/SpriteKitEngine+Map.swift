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
    public var cache : Bool {
        return true
    }
    
    public func newInstance() -> Self {
        return copy() as! Self
    }
}

public extension SpriteKitEngine {
    typealias MapType = SKScene

    static func make(mapFor tiledMap: Map) throws -> SKScene {
        let scene = SKScene(size: tiledMap.pixelSize.cgSize)
        
        #warning("API Issue: How do we ensure scenes always have a userData property if other factories go first? Validation from the core or make like a processor?")
        scene.userData = NSMutableDictionary()

        scene.backgroundColor = tiledMap.backgroundColor?.skColor ?? SKColor.darkGray

        scene.apply(propertiesFrom: tiledMap)

        return scene
    }
    
    static func postProcess(_ scene: SKScene, for map: Map, from project: Project) throws -> SKScene {
        // Add a camera to apply the transform to the level
        let camera = SKCameraNode()
        camera.position = CGPoint(x: scene.size.width/2, y: scene.size.height / -2)

        scene.addChild(camera)
        scene.camera = camera

        return scene
    }
}
