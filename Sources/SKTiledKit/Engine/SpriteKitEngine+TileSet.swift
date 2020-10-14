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

public extension SpriteKitEngine {
//    typealias TileType = SKSpriteNode // Deep copyable
//    typealias ImageLayerType = SKSpriteNode
    typealias SpriteType = SKSpriteNode

    static func make(spriteFor tile: Tile, in tileset: TileSet, with texture: SKTexture, from project: Project) throws -> SKSpriteNode {
        
        #warning("Bounds need to be normalized")
        let sprite = SKSpriteNode(texture: SKTexture(rect: tile.bounds.cgRect, in: texture))
        
        return sprite
    }
    
    static func postProcess(_ sprite: SKSpriteNode, from tile: Tile, in tileSet: TileSet, with setSprites: [UInt32 : SKSpriteNode], for map: Map, from project: Project) throws -> SKSpriteNode {
        
        #warning("Should be building animation frames etc")
        return sprite
    }
}
