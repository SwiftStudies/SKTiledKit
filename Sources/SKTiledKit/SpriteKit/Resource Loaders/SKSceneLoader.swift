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

extension SKScene {
    
    public static func loader(for project: Project) -> ResourceLoader {
        return SKSceneLoader(project: project)
    }
    
    public var cache : Bool {
        return true
    }
    
    public func newInstance() -> Self {
        return copy() as! Self
    }
}


public struct SKSceneLoader : ResourceLoader {
    let project : Project
    
    public func retrieve<R>(asType: R.Type, from url: URL) throws -> R {
        let map = try project.retrieve(asType: Map.self, from: url)

        let scene = SKTKScene()
        
        try apply(map: map, to: scene)
        
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
    
    /// Creates a shape node for the supplied path
    ///
    /// - Parameters:
    ///   - path: Path built in SpriteKit co-ordinate space
    ///   - position: Position in Tiled co-ordinate space
    ///   - degrees: The rotation in degrees (as specified in Tiled
    ///   - centered: If true the shape will be positioned as it was in tiled, but the center of rotation will be the center of the shape
    /// - Returns: The created node
    func shapeNode(with path:CGPath, position:CGPoint, rotation degrees:Double, centered:Bool) -> SKTKShapeNode{
        let position = position.transform()
        let radians = -degrees.cgFloatValue.radians
        
        var path = path
        //Rotate to create a new path
        var rotationTransform = CGAffineTransform(rotationAngle: radians)

        #warning("Force unwrap")
        path = path.copy(using: &rotationTransform)!

        if !centered {
            let shapeNode = SKTKShapeNode(path: path)
            shapeNode.position = position
            return shapeNode
        }
        
        var total = 0
        var xSum : CGFloat = 0
        var ySum : CGFloat = 0
        
        path.applyWithBlock { (pathElementPointer) in
            
            if !pathElementPointer.pointee.points.pointee.x.isNaN {
                xSum += pathElementPointer.pointee.points.pointee.x
                ySum += pathElementPointer.pointee.points.pointee.y
                total += 1
            }
        }
        
        let center = CGPoint( x: xSum / total.cgFloatValue, y: ySum / total.cgFloatValue)
        
        var centeringTransform = CGAffineTransform(translationX: -center.x, y: -center.y)
        
        #warning("Force unwrap")
        path = path.copy(using: &centeringTransform)!
        
        let shapeNode = SKTKShapeNode(path: path)
        shapeNode.position = position
        shapeNode.position.x += center.x
        shapeNode.position.y += center.y
        
        return shapeNode
    }
    
    public func add(_ objects: [Object], to container: SKNode, in map:Map) throws {
        
        for object in objects {
            
            var objectNode : SKNode? = nil
            
            switch object.kind {
            case .point:
                let pointNode = SKTKShapeNode(circleOfRadius: 1)
                
                pointNode.position = object.position.cgPoint.transform()
                
                objectNode = pointNode
            case .polygon(_, let angle), .polyline(_, let angle), .ellipse(_, let angle), .rectangle(_, let angle):
                guard let path = object.cgPath else {
                    fatalError("Could not generate path for Polygonal Object")
                }
                
                objectNode = shapeNode(with: path, position: object.position.cgPoint, rotation: angle, centered: true)
            case .tile(let tileGid, _, _):
                guard let tile = map[tileGid] else {
                    throw SKTiledKitError.tileNotFound
                }
                
                let tileNode = try project.retrieve(asType: SKSpriteNode.self, from: tile.cachingUrl)
                                
                let size = tileNode.calculateAccumulatedFrame().size
                
                tileNode.anchorPoint = .zero
                tileNode.position = object.position.cgPoint.transform()
                tileNode.zRotation = object.zRotation
                tileNode.xScale = size.width.cgFloatValue / size.width
                tileNode.yScale = size.height.cgFloatValue / size.height
                
                objectNode = tileNode
            case .text(let string, let size, _, let style):
                let rect = CGRect(origin: .zero, size: size.cgSize.transform())

                let textNode = SKTKTextNode(path: CGPath(rect: rect, transform: nil))

                textNode.add(string, applying: style)
                if object.properties["showTextNodePath"] == true {
                    textNode.strokeColor = SKColor.white
                }

                textNode.position = object.position.cgPoint.transform()
                textNode.zRotation = object.zRotation

                objectNode = textNode

            }
        
            if let objectNode = objectNode {
                objectNode.name = object.name
                objectNode.isHidden = !object.visible
                objectNode.apply(propertiesFrom: object)
                
                if case let PropertyValue.color(strokeColor) = object.properties["strokeColor"] ?? .bool(false), let shapeNode = objectNode as? SKShapeNode {
                    shapeNode.strokeColor = strokeColor.skColor
                }
                
                container.addChild(objectNode)
            }
            
        }
    }
    
    internal func walk(_ layers:[Layer], in map:Map, with parent:SKNode) throws {
        for layer in layers {
            switch layer.kind {
            
            case .tile(let tileGrid):
                let tileLayerNode = SKTKNode()
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
                
                parent.addChild(tileLayerNode)
            case .objects(let objects):
                let objectLayerNode = SKNode()
                configure(objectLayerNode, for: layer)

                try add(objects, to: objectLayerNode, in: map)
                
                parent.addChild(objectLayerNode)
            case .group(let group):
                let node = SKTKNode()
                configure(node, for: layer)
                try walk(group.layers, in: map, with: node)
                parent.addChild(node)
            case .image(let image):
                let texture = try project.retrieve(textureFrom: image.source, filteringMode: layer.properties["filteringMode"])

                let spriteNode = SKTKSpriteNode(texture: texture)
                configure(spriteNode, for: layer)
                
                // Position has to be adjusted because it has a different anchor
                spriteNode.position = CGRect(origin: layer.position.cgPoint, size: image.size.cgSize).transform(with: spriteNode.anchorPoint).origin
                
                parent.addChild(spriteNode)
            }
        }
    }
    
    internal func apply(map : Map, to scene:SKScene) throws {
        scene.size = map.pixelSize.cgSize

        scene.userData = NSMutableDictionary()

        scene.apply(propertiesFrom: map)
        
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
    
    internal func createTileNode(_ tile:Tile, from tileset:TileSet, using texture:SKTexture) {
        let node = SKTKSpriteNode(texture: texture)
        node.userData = NSMutableDictionary()

        // No matter what happens, store the node in the cache before returning
        defer {
            project.store(node, as: tile.cachingUrl)
        }

        let accumulatedFrame = node.calculateAccumulatedFrame()

        if let bodyParts = tile.collisionBodies?.compactMap({ (object) -> SKPhysicsBody? in
            if let path = object.cgPath {
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
                let subTexture = SKTexture(rect: scale(tile.bounds.cgRect, to: texture), in: texture)
                subTexture.filteringMode = SKTextureFilteringMode(withPropertiesFrom: tileset)
                createTileNode(tile, from: tileset, using: subTexture)
            } else {
                createTileNode(tile, from: tileset, using: texture)
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
                let currentTileSprite = try project.retrieve(asType: SKTKSpriteNode.self, from: tile.cachingUrl)
                currentTileSprite.run(SKAction.repeatForever(SKAction.sequence(animationSteps)))
                project.store(currentTileSprite, as: tile.cachingUrl)
            }
        }
    }
}
