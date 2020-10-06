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
    
    static var mapProcessors : [MapProcessor] = [
        CameraProcessor.default,
    ]
    
    static var layerProcessors  : [LayerProcessor] = [
        
    ]
    
    static var objectProcessors : [ObjectProcessor] = [
        DefaultObjectProcessor(),
        CameraProcessor.default,
    ]

    public static func prepend(tileProcessor:TileProcessor){
        tileProcessors.insert(tileProcessor, at: 0)
    }

    public static func append(tileProcessor:TileProcessor){
        tileProcessors.append(tileProcessor)
    }
    
    public static func prepend(objectProcessor:ObjectProcessor){
        objectProcessors.insert(objectProcessor, at: 0)
    }

    public static func append(objectProcessor:ObjectProcessor){
        objectProcessors.append(objectProcessor)
    }

    public static func prepend(layerProcessor:LayerProcessor){
        layerProcessors.insert(layerProcessor, at: 0)
    }

    public static func append(layerProcessor:LayerProcessor){
        layerProcessors.append(layerProcessor)
    }

    public static func prepend(mapProcessor:MapProcessor){
        mapProcessors.insert(mapProcessor, at: 0)
    }

    public static func append(mapProcessor:MapProcessor){
        mapProcessors.append(mapProcessor)
    }

    let project : Project
        
    public func retrieve<R>(asType: R.Type, from url: URL) throws -> R {
        let map = try project.retrieve(asType: Map.self, from: url)

        var scene : SKScene!
        for mapProcessor in Self.mapProcessors {
            if let createdScene = try mapProcessor.willCreate(sceneFor: map, from: project) {
                scene = createdScene
                break
            }
        }
        
        if scene == nil {
            scene = SKScene()
        }
                
        try apply(map: map, to: scene)
        
        for mapProcessor in Self.mapProcessors {
            scene = try mapProcessor.didCreate(scene, for: map, from: project)
        }
        
        guard let generatedScene = scene as? R else {
            throw SceneLoadingError.sceneCouldNotReturned
        }
        
        return generatedScene
    }
    
    internal func configure(_ node:SKNode, for layer:Layer){
        node.name = layer.name
        node.isHidden = !layer.visible
        node.alpha = layer.opacity.cgFloatValue
        node.apply(propertiesFrom: layer)
        node.position = layer.position.cgPoint.transform()
    }
    
    
    public func add(_ objects: [Object], from layer:Layer, to container: SKNode, in map:Map) throws {
        
        for object in objects {
            var objectNode : SKNode! = nil

            for objectProcessor in Self.objectProcessors {
                if let createdNode = try objectProcessor.willCreate(nodeFor: object, in: layer, and: map, from: project) {
                    objectNode = createdNode
                    break
                }
            }


            // Always tag the node with the objectId
            objectNode.userData = NSMutableDictionary()
            objectNode.userData?["tiledId"] = object.id
            
            for objectProcessor in Self.objectProcessors {
                objectNode = try objectProcessor.didCreate(objectNode, for: object, in: layer, and: map, from: project)
            }

            container.addChild(objectNode)
        }
    }
    
    internal func walk(_ layers:[Layer], in map:Map, with parent:SKNode) throws {
        
        for layer in layers {
            var layerNode : SKNode!
            
            for layerProcessor in Self.layerProcessors {
                if let createdNode = try layerProcessor.willCreate(nodeFor: layer, in: map, from: project){
                    layerNode = createdNode
                    break
                }
            }
            
            if layerNode == nil {
                switch layer.kind {
                
                case .tile(let tileGrid):
                    let tileLayerNode = SKNode()
                    configure(tileLayerNode, for: layer)
                    
                    for x in 0..<tileGrid.size.width {
                        for y in 0..<tileGrid.size.height {
                            let tileGid = tileGrid[x,y]
                            
                            if tileGid.globalTileOffset > 0 {
                                guard let tile = map[tileGid] else {
                                    throw SKTiledKitError.tileNotFound
                                }

                                // TileSets were pre-loaded by the map before we got here
                                let tileNode = try project.retrieve(asType: SKSpriteNode.self, from: tile.cachingUrl)

                                tileNode.position = CGRect(x: x * map.tileSize.width, y: y * map.tileSize.height, width: map.tileSize.width, height: map.tileSize.height).transform(with: tileNode.anchorPoint).origin
                                
                                tileLayerNode.addChild(tileNode)
                            }
                        }
                    }
                    
                    layerNode = tileLayerNode
                case .objects(let objects):
                    let objectLayerNode = SKNode()
                    configure(objectLayerNode, for: layer)

                    try add(objects, from: layer, to: objectLayerNode, in: map)
                    
                    layerNode = objectLayerNode
                case .group(let group):
                    let node = SKNode()
                    configure(node, for: layer)
                    try walk(group.layers, in: map, with: node)
                    
                    layerNode = node
                case .image(let image):
                    let texture = try project.retrieve(textureFrom: image.source, filteringMode: layer.properties["filteringMode"])

                    let spriteNode = SKSpriteNode(texture: texture)
                    configure(spriteNode, for: layer)
                    
                    // Position has to be adjusted because it has a different anchor
                    spriteNode.position = CGRect(origin: layer.position.cgPoint, size: image.size.cgSize).transform(with: spriteNode.anchorPoint).origin
                    
                    
                    layerNode = spriteNode
                }
            }

            for layerProcessor in Self.layerProcessors {
                layerNode = try layerProcessor.didCreate(layerNode, for: layer, in: map, from: project)
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
