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

public class SpriteKitEngine : Engine {
    public typealias MapType = SKScene
    public typealias TextureType = SKTexture
    public typealias SpriteType = SKSpriteNode
    
    public typealias FloatType = CGFloat
    public typealias ColorType = SKColor
    
    public static func load(textureFrom url: URL, in project: Project) throws -> SKTexture {
        return try project.retrieve(asType: SKTexture.self, from: url)
    }
    
    public static func make(engineMapForTiled map: Map) throws -> SKScene {
        return SKScene(size: map.pixelSize.cgSize)
    }
    
    public static func postProcess(_ specializedMap: SKScene, for map: Map, from project: Project) throws -> SKScene {
        return specializedMap
    }
    
    public static func make(spriteFor tile: Tile, in tileset: TileSet, with texture: SKTexture, from project: Project) throws -> SKSpriteNode {
        
        #warning("Bounds need to be normalized")
        let sprite = SKSpriteNode(texture: SKTexture(rect: tile.bounds.cgRect, in: texture))
        
        return sprite
    }
    
    public static func postProcess(_ sprite: SKSpriteNode, from tile: Tile, in tileSet: TileSet, with setSprites: [UInt32 : SKSpriteNode], for map: Map, from project: Project) throws -> SKSpriteNode {
        
        #warning("Should be building animation frames etc")
        return sprite
    }
}

extension SKSpriteNode : EngineObject, DeepCopyable {
    public typealias EngineType = SpriteKitEngine
    
    public func deepCopy() -> Self {
        return copy() as! Self
    }
    
    
}

extension SKTexture : EngineTexture {
    public typealias EngineType = SpriteKitEngine
}

extension SKScene : EngineMap {
    public typealias EngineType = SpriteKitEngine
    
    
}
