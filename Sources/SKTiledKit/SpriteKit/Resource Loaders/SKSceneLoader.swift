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
    
    public func add(_ objects: [Object], to container: SKNode) throws {
        
        for object in objects {
            
            var objectNode : SKNode? = nil
            
            switch object.kind {
            case .point:
                let pointNode = SKTKShapeNode(circleOfRadius: 1)
                
                pointNode.position = CGPoint(x: point.x, y: point.y).transform()
                
                objectNode = pointNode
            case .rectangle(_, angle: let angle):
                guard let path = rectangle.cgPath else {
                    fatalError("Could not generate path for RectangleObject")
                }
                
                objectNode = shapeNode(with: path, position: CGPoint(x:rectangle.x,y:rectangle.y), rotation: rectangle.rotation, centered: true)
            case .ellipse(_, angle: let angle):
                guard let path = elipse.cgPath else {
                    fatalError("Could not generate path for elipse")
                }
                
                objectNode = shapeNode(with: path, position: CGPoint(x:elipse.x,y:elipse.y), rotation: elipse.rotation, centered: true)
            case .tile(_, size: let size, angle: let angle):
                guard let tile = tileObject.level.tiles[tileObject.gid] else {
                    throw SKTiledKitError.tileNotFound
                }
                let cachedNode = SKTileSets.tileCache[tile.uuid]
                guard let tileNode = cachedNode?.copy() as? SKTKSpriteNode else {
                    throw SKTiledKitError.tileNodeDoesNotExist
                }
                
                let size = tileNode.calculateAccumulatedFrame().size
                
                tileNode.anchorPoint = .zero
                tileNode.position = CGPoint(x: tileObject.x, y: tileObject.y).transform()
                tileNode.zRotation = -tileObject.rotation.cgFloatValue.radians
                tileNode.xScale = tileObject.width.cgFloatValue / size.width
                tileNode.yScale = tileObject.height.cgFloatValue / size.height
                
                objectNode = tileNode
            case .text(_, size: let size, angle: let angle, style: let style):
                let rect = CGRect(origin: .zero, size: CGSize(width: textObject.width, height: textObject.height).transform())

                let textNode = SKTKTextNode(path: CGPath(rect: rect, transform: nil))

                textNode.add(textObject.string, applying: textObject.style)
                if object.showTextNodePath == true {
                    textNode.strokeColor = SKColor.white
                }

                textNode.position = CGPoint(x: textObject.x, y: textObject.y).transform()
                textNode.zRotation = -textObject.rotation.radians.cgFloatValue

                objectNode = textNode
            case .polygon(pointPath, angle: let angle):
                guard let path = polygon.cgPath else {
                    fatalError("Could not generate path for Polygonal Object")
                }
                
                objectNode = shapeNode(with: path, position: CGPoint(x: polygon.x, y: polygon.y), rotation: polygon.rotation, centered: true)
            case .polyline(pointPath, angle: let angle):
                guard let path = polygon.cgPath else {
                    fatalError("Could not generate path for Polygonal Object")
                }
                
                objectNode = shapeNode(with: path, position: CGPoint(x: polygon.x, y: polygon.y), rotation: polygon.rotation, centered: true)
            }
        
            if let objectNode = objectNode {
                objectNode.name = object.name
                objectNode.isHidden = !object.visible
                objectNode.apply(propertiesFrom: object)
                
                if let strokeColor : Color = object.strokeColor, let shapeNode = objectNode as? SKShapeNode {
                    shapeNode.strokeColor = strokeColor.skColor
                }
                
                objectLayerNode.addChild(objectNode)
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
                            
                            #warning("Forced unwrap")
                            #warning("These should have all be pre-loaded via the loading of the tile sets before walk begain")
                            // Read the warning above
                            let tileNode = try project.retrieve(asType: SKTKNode.self, from: URL(inMemory: "TileNode", tile.uuid)!)

                            tileNode.position = CGRect(x: x * map.tileSize.width, y: y * map.tileSize.height, width: map.tileSize.width, height: map.tileSize.height).transform(with: tileNode.anchorPoint).origin
                            
                            tileLayerNode.addChild(tileNode)
                        }
                    }
                }
                
                parent.addChild(tileLayerNode)
            case .objects(let objects):
                let objectLayerNode = SKNode()
                configure(objectLayerNode, for: layer)

                add(objects, to: objectLayerNode)
                
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
            
        }
        
        // Prepare the remaining layers
        try walk(map.layers, in: map, with: scene)
        
        // Add a camera to apply the transform to the level
        let camera = SKCameraNode()
        camera.position = CGPoint(x: scene.size.width/2, y: scene.size.height / -2)
        
        scene.addChild(camera)
        scene.camera = camera
    }
    
}
