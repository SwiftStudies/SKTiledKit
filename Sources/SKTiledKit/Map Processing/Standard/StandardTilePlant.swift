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

public struct StandardTilePlant : TileFactory, TileProcessor {
    public func process(_ sprite: SKSpriteNode, for tile: Tile, in tileset: TileSet, from project: Project) throws -> SKSpriteNode {
        
        var animationSteps = [SKAction]()
        for frame in tile.frames ?? [] {
            if let texture = try project.retrieve(asType: SKSpriteNode.self, from: frame.tile.cachingUrl).texture {
                animationSteps.append(SKAction.setTexture(texture))
                animationSteps.append(SKAction.wait(forDuration: frame.duration))
            } else {
                SceneLoader.warn("No texture for \(tileset.name).\(tile.uuid)")
            }
        }
        
        // If we have frames add an animation action
        if animationSteps.count > 0 {
            let currentTileSprite = try project.retrieve(asType: SKSpriteNode.self, from: tile.cachingUrl)
            currentTileSprite.run(SKAction.repeatForever(SKAction.sequence(animationSteps)))
        }
        
        return sprite
    }
    
    public func make(spriteFor tile: Tile, id:UInt32, in tileset: TileSet, with texture: SKTexture, from project: Project, processingObjectsWith objectPostProcessors:[ObjectPostProcessor]) -> SKSpriteNode? {
        var node = SKSpriteNode(texture: texture)
        node.userData = NSMutableDictionary()

        // No matter what happens, store the node in the cache before returning
        defer {
            project.store(node, as: tile.cachingUrl)
        }


        if let bodyParts = tile.collisionBodies?.compactMap({ (object) -> SKPhysicsBody? in
            if let path = object.cgPath {
                let accumulatedFrame = node.calculateAccumulatedFrame()
                let rotation = object.zRotation
                var translation = object.position.cgPoint.transform()
                
                translation.y += accumulatedFrame.height
                
                return SKPhysicsBody(polygonFrom: path.apply(CGAffineTransform(rotationAngle: rotation)).apply(CGAffineTransform(translationX: translation.x, y: translation.y)))
            }
            return nil
        }){
            if bodyParts.count == 1{
                node.physicsBody = bodyParts[0]
            } else {
                node.physicsBody = SKPhysicsBody(bodies: bodyParts)
            }
//            let collisionBody = SKPhysicsBody(bodies: bodyParts)
//            collisionBody.affectedByGravity = false
//            node.physicsBody = collisionBody
        }
        
        for postProcessor in objectPostProcessors {
            do {
                guard let newNode = try postProcessor.process(node, of: tile.type, with: tile.properties) as? SKSpriteNode else {
                    SceneLoader.warn("ObjectPostProcessor returned a non SKSpriteNode")
                    continue
                }
                node = newNode
            } catch {
                SceneLoader.warn("\(error) during tile sprite processing")
            }
        }

        return node
    }

}
