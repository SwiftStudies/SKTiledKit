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
        
        let texture = try make(textureFrom: tile.imageSource, with: tile.bounds, and: tileset.properties.overridingWith(tile.properties), in: project)
        
        let sprite = SKSpriteNode(texture: texture)
        #warning("API: Again, how do we ensure specializations don't miss this?")
        sprite.userData = NSMutableDictionary()
        
        // Make the basic tile
        if let bodyParts = tile.collisionBodies?.compactMap({ (object) -> SKPhysicsBody? in
            if let path = object.cgPath {
                let accumulatedFrame = sprite.calculateAccumulatedFrame()
                let rotation = object.zRotation
                var translation = object.position.cgPoint.transform()
                
                translation.y += accumulatedFrame.height
                
                return SKPhysicsBody(polygonFrom: path.apply(CGAffineTransform(rotationAngle: rotation)).apply(CGAffineTransform(translationX: translation.x, y: translation.y)))
            }
            return nil
        }){
            if bodyParts.count == 1{
                sprite.physicsBody = bodyParts[0]
            } else {
                sprite.physicsBody = SKPhysicsBody(bodies: bodyParts)
            }
        }
        
        return sprite
    }
    
    #warning("API: tileSet parameter misspelled, should be tileset (all lowercase)")
    static func process(_ sprite: SKSpriteNode, from tile: Tile, in tileSet: TileSet, with setSprites: [UInt32 : SKSpriteNode], for map: Map, from project: Project) throws -> SKSpriteNode {
        
        var animationSteps = [SKAction]()
        for frame in tile.frames ?? [] {
            if let tileId = tileSet.localId(of: frame.tile), let texture = setSprites[tileId]?.texture {
                animationSteps.append(SKAction.setTexture(texture))
                animationSteps.append(SKAction.wait(forDuration: frame.duration))
            } else {
                SpriteKitEngine.warn("No texture for \(tileSet.name).\(tile.uuid)")
            }
        }
        
        // If we have frames add an animation action
        if animationSteps.count > 0 {
            let currentTileSprite = sprite
            currentTileSprite.run(SKAction.repeatForever(SKAction.sequence(animationSteps)))
            
            return currentTileSprite
        } else {
            return sprite
        }
        
    }
}
