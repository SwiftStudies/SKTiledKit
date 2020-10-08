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
    case couldNotCreateTile(UInt32, tileSet:String)
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
        LightFactory(),
        StandardLayerFactory(),
        StandardObjectFactory(),
        StandardTexturePlant(),
        StandardTilePlant(),
    ]
    
    public static var postProcessors : [PostProcessor] = [
        StandardTilePlant(),
        StandardTexturePlant(),
        EdgeLoopProcessor(),
        PhysicsPropertiesPostProcessor(),
        PropertyPostProcessor<SKSpriteNode>(with: LitSpriteProperty.allCases),
        PropertyPostProcessor<SKLightNode>(for:"SKLight",with: LightProperty.allCases),
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
    
    var textureFactories : [TextureFactory] {
        return Self.factories.compactMap {
            return $0 as? TextureFactory
        }
    }
    
    var tileFactories : [TileFactory] {
        return Self.factories.compactMap {
            return $0 as? TileFactory
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

    var texturePostProcessors : [TextureProcessor] {
        return Self.postProcessors.compactMap {
            return $0 as? TextureProcessor
        }
    }

    var tilePostProcessors : [TileProcessor] {
        return Self.postProcessors.compactMap {
            return $0 as? TileProcessor
        }
    }
    
    public static func warn(_ message:String){
        print("Warning:\(message)")
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
            
            for factory in layerFactories {
                if let createdNode = try factory.make(nodeFor: layer, in: map, from: project){
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
    
    internal func load(_ tileset:TileSet) throws {
        
        var tileSpriteCache = [UInt32:SKSpriteNode]()
        
        for tileId : UInt32 in 0..<UInt32(tileset.count) {
            guard let tile = tileset[tileId] else {
                throw SceneLoadingError.tileNotFound(tileId, tileSet: tileset.name)
            }
            
            // Make the texture
            var builtTexture : SKTexture?
            for textureFactory in textureFactories {
                if let createdTexture = try textureFactory.make(textureFor: tile.imageSource, with: tile.bounds, from: project) {
                    builtTexture = createdTexture
                    break
                }
            }
            
            // Make sure we have a texture
            guard var texture = builtTexture else {
                throw SceneLoadingError.textureCouldNotBeReturned
            }
            
            // Post process it
            for texturePostProcessor in texturePostProcessors {
                texture = try texturePostProcessor.process(texture, for: tile, in: tileset, from: project)
            }
            
            // Make and post process the tile
            var builtSprite : SKSpriteNode?
            for tileFactory in tileFactories {
                if let createdSprite = try tileFactory.make(spriteFor: tile, id: tileId, in: tileset, with: texture, from: project, processingObjectsWith: objectPostProcessors) {
                    builtSprite = createdSprite
                    break
                }
            }
            
            if builtSprite == nil {
                throw  SceneLoadingError.couldNotCreateTile(tileId, tileSet: tileset.name)
            }
            
            tileSpriteCache[tileId] = builtSprite
        }
        
        
        //Post process tiles
        for tileId : UInt32 in 0..<UInt32(tileset.count) {
            guard let tile = tileset[tileId] else {
                throw SceneLoadingError.tileNotFound(tileId, tileSet: tileset.name)
            }
            
            guard var sprite = tileSpriteCache[tileId] else {
                throw SceneLoadingError.couldNotCreateTile(tileId, tileSet: tileset.name)
            }
            
            for postProcessor in tilePostProcessors {
                sprite = try postProcessor.process(sprite, for: tile, in: tileset, from: project)
            }

            #warning("Error occurs here")
            project.store(sprite, as: tile.cachingUrl)
        }
    }
}
