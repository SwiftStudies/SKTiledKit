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

enum SceneLoadingError : Error {
    case sceneCouldNotReturned
    case textureCouldNotBeReturned
    case attemptToLoadInMemoryResourceFrom(URL)
    case tileNotFound(UInt32, tileSet:String)
}

public extension Project {
    func retrieve(scene name:String, in subdirectory:String? = nil) throws -> SKScene {
        return try retrieve(asType: SKScene.self, from: name, in: subdirectory, of: .tmx)
    }
}

extension SKScene : Loadable {
    
    public static func loader(for project: Project) -> ResourceLoader {
        return SceneLoader(project: project)
    }
    
    public var cache : Bool {
        return true
    }
    
    public func newInstance() -> Self {
        return copy() as! Self
    }
}


public struct SceneLoader : ResourceLoader {
    static var tileProcessors = [TileProcessor]()
    
    public static var factories : [Factory] = [
        StandardLayerFactory(),
        StandardObjectFactory(),
    ]
    
    public static var postProcessors : [PostProcessor] = [
        CameraProcessor(),
    ]
    
    let project : Project
        
    var mapFactories : [MapFactory] {
        return Self.factories.compactMap {
            return $0 as? MapFactory
        }
    }

    var layerFactories : [LayerFactory] {
        return Self.factories.compactMap {
            return $0 as? LayerFactory
        }
    }

    var objectFactories : [ObjectFactory] {
        return Self.factories.compactMap {
            return $0 as? ObjectFactory
        }
    }
    
    var mapPostProcessors : [MapPostProcessor] {
        return Self.postProcessors.compactMap {
            return $0 as? MapPostProcessor
        }
    }

    var layerPostProcessors : [LayerPostProcessor] {
        return Self.postProcessors.compactMap {
            return $0 as? LayerPostProcessor
        }
    }

    var objectPostProcessors : [ObjectPostProcessor] {
        return Self.postProcessors.compactMap {
            return $0 as? ObjectPostProcessor
        }
    }

    public func retrieve<R>(asType: R.Type, from url: URL) throws -> R {
        let map = try project.retrieve(asType: Map.self, from: url)

        var scene : SKScene!
        for mapProcessor in mapFactories {
            if let createdScene = try mapProcessor.make(sceneFor: map, from: project) {
                scene = createdScene
                break
            }
        }
        
        if scene == nil {
            scene = SKScene()
        }
                
        try apply(map: map, to: scene)
        
        for mapProcessor in mapPostProcessors {
            scene = try mapProcessor.process(scene, for: map, from: project)
        }
        
        guard let generatedScene = scene as? R else {
            throw SceneLoadingError.sceneCouldNotReturned
        }
        
        return generatedScene
    }
    
    public func walk(_ objects: [Object], from layer:Layer, to container: SKNode, in map:Map) throws {
        
        for object in objects {
            var objectNode : SKNode! = nil

            for objectProcessor in objectFactories {
                if let createdNode = try objectProcessor.make(nodeFor: object, in: layer, and: map, from: project) {
                    objectNode = createdNode
                    break
                }
            }


            // Always tag the node with the objectId
            objectNode.userData = NSMutableDictionary()
            objectNode.userData?["tiledId"] = object.id
            
            for objectProcessor in objectPostProcessors {
                objectNode = try objectProcessor.process(objectNode, for: object, in: layer, and: map, from: project)
            }

            container.addChild(objectNode)
        }
    }
    
    public func walk(_ layers:[Layer], in map:Map, with parent:SKNode) throws {
        
        for layer in layers {
            var layerNode : SKNode!
            
            for layerProcessor in layerFactories {
                if let createdNode = try layerProcessor.make(nodeFor: layer, in: map, from: project){
                    layerNode = createdNode
                    break
                }
            }
            
            switch layer.kind {
            case .group(let group):
                try walk(group.layers, in: map, with: layerNode)
            case .objects(let objects):
                try walk(objects, from: layer, to: layerNode, in: map)
            default:
                break
            }

            for layerProcessor in layerPostProcessors {
                layerNode = try layerProcessor.process(layerNode, for: layer, in: map, from: project)
            }
            
            parent.addChild(layerNode)
        }
    }
    
    internal func apply(map : Map, to scene:SKScene) throws {
        scene.size = map.pixelSize.cgSize

        scene.userData = NSMutableDictionary()

        scene.apply(propertiesFrom: map)
        if let mapBackgroundColor = map.backgroundColor {
            scene.backgroundColor = mapBackgroundColor.skColor
        }
        
        for tileSet in map.tileSets {
            try load(tileSet)
        }
        
        // Prepare the remaining layers
        try walk(map.layers, in: map, with: scene)
        
        // Add a camera to apply the transform to the level
        let camera = SKCameraNode()
        camera.position = CGPoint(x: scene.size.width/2, y: scene.size.height / -2)
        
        scene.addChild(camera)
        scene.camera = camera
    }
    
    internal func createTileNode(_ tile:Tile, id tileId:UInt32, from tileset:TileSet, using texture:SKTexture) {
        let node = SKSpriteNode(texture: texture)
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
            let collisionBody = SKPhysicsBody(bodies: bodyParts)
            collisionBody.affectedByGravity = false
            node.physicsBody = collisionBody
        }
    }
    
    internal func load(_ tileset:TileSet) throws {
        
        func scale(_ bounds:CGRect, to texture: SKTexture) -> CGRect {
            return CGRect(x: bounds.origin.x / texture.size().width,
                          y: bounds.origin.y / texture.size().height,
                          width: bounds.size.width / texture.size().width,
                          height: bounds.size.height / texture.size().height)
        }
        
        for tileId : UInt32 in 0..<UInt32(tileset.count) {
            guard let tile = tileset[tileId] else {
                throw SceneLoadingError.tileNotFound(tileId, tileSet: tileset.name)
            }
            
            let texture = try project.retrieve(asType: SKTexture.self, from: tile.imageSource)
            texture.filteringMode = SKTextureFilteringMode(withPropertiesFrom: tileset)
            
            if texture.size() != tile.bounds.size.cgSize {
                var textureBounds = scale(tile.bounds.cgRect, to: texture)
                textureBounds.origin.y = (1 - textureBounds.origin.y) - textureBounds.size.height
                let subTexture = SKTexture(rect: textureBounds, in: texture)
                subTexture.filteringMode = SKTextureFilteringMode(withPropertiesFrom: tileset)
                createTileNode(tile, id: tileId, from: tileset, using: subTexture)
            } else {
                createTileNode(tile, id: tileId, from: tileset, using: texture)
            }
        }
        
        //Create animations
        for tileId : UInt32 in 0..<UInt32(tileset.count) {
            guard let tile = tileset[tileId] else {
                throw SceneLoadingError.tileNotFound(tileId, tileSet: tileset.name)
            }
            var animationSteps = [SKAction]()
            for frame in tile.frames ?? [] {
                if let texture = try project.retrieve(asType: SKSpriteNode.self, from: frame.tile.cachingUrl).texture {
                    animationSteps.append(SKAction.setTexture(texture))
                    animationSteps.append(SKAction.wait(forDuration: frame.duration))
                } else {
                    print("WARNING: No texture for \(tileset.name).\(tile.uuid)")
                }
            }
            
            // If we have frames, update the cache
            if animationSteps.count > 0 {
                let currentTileSprite = try project.retrieve(asType: SKSpriteNode.self, from: tile.cachingUrl)
                currentTileSprite.run(SKAction.repeatForever(SKAction.sequence(animationSteps)))
                project.store(currentTileSprite, as: tile.cachingUrl)
            }
        }
    }
}
