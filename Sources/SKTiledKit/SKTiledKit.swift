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

public enum SKTiledKitError : Error {
    case tileNodeDoesNotExist
    case tileNotFound
    case notImplemented
    case missingPathForTile(tile:String)
    case couldNotLoadImage(url:URL)
    case imageFileNotFound(url:URL)
    case couldNotCreateImage(url:URL)
    case noPositionForTile(identifier:Int, tileSet:String)
}

extension Level {
    var heightInPixels : CGFloat {
        return (height * tileHeight).cgFloatValue
    }
    
    func transform(y:Double, objectHeight height:Double = 0)->CGFloat{
        let levelHeight = Double(self.height) * Double(self.tileHeight)
        
        return CGFloat((levelHeight - y) - (height / 2))
    }
}

extension SKNode {
    func transformY(for level:Level)->CGFloat{
        return level.transform(y: Double(position.y), objectHeight: Double(calculateAccumulatedFrame().size.height))
    }
}



extension SKScene : SpecializedLevel {
    public typealias Container = SKNode
    
    public var primaryContainer: Container {
        return self
    }

    public func apply(tiledLevel level: Level) {
        scene?.size =  CGSize(width: CGFloat(level.width*level.tileWidth), height: CGFloat(level.height*level.tileHeight))
        scene?.userData = NSMutableDictionary()

        apply(propertiesFrom: level)
    }
    
    public func create(tileSet: TileSet) throws {
        try SKTileSets.load(tileSet)        
    }
    
    #warning("This may not be necessary")
    public func add(tile: Int, to tileSet: TileSet) throws {
        throw SKTiledKitError.notImplemented
    }
    
    public func add(tileLayer: TileLayer, to container: Container) throws {
        
        let tileLayerNode = SKTKNode()
                
        tileLayerNode.name = tileLayer.name
        tileLayerNode.isHidden = !tileLayer.visible
        tileLayerNode.alpha = CGFloat(tileLayer.opacity)
        tileLayerNode.apply(propertiesFrom: tileLayer)
        
        for x in 0..<tileLayer.level.width {
            for y in 0..<tileLayer.level.height {
                #warning("Forced unwrap")
                let tileMapOffset = y*tileLayer.level.width+x
                let levelTileOffset = tileLayer.tiles[tileMapOffset]
                
                if levelTileOffset > 0 {
                    guard let tile = tileLayer.level.tiles[levelTileOffset] else {
                        throw SKTiledKitError.tileNotFound
                    }
                    let cachedNode = SKTileSets.tileCache[tile.uuid]
                    guard let tileNode = cachedNode?.copy() as? SKNode else {
                        throw SKTiledKitError.tileNodeDoesNotExist
                    }
                    #warning("Force unwrap")
                    tileNode.position = CGPoint(x: x * tileLayer.level.tileWidth + (tile.tileSet!.tileWidth / 2), y: y * tileLayer.level.tileHeight)
                    
                    tileNode.position.y = tileNode.transformY(for: tileLayer.level)
                    
                    tileLayerNode.addChild(tileNode)
                }
            }
        }
        
        container.addChild(tileLayerNode)
    }
    
    public func add(group: GroupLayer, to container: Container) throws -> Container {
        let node = SKTKNode()
        
        node.name = group.name
        node.isHidden = !group.visible
        node.alpha = CGFloat(group.opacity)
        node.apply(propertiesFrom: group)
        
        container.addChild(node)
        
        return container
    }

    #warning("Not implemented")
    public func add(image: ImageLayer, to container: Container) throws {
        let texture = try SKTileSets.load(texture: image.url)
        
        let spriteNode = SKTKSpriteNode(texture: texture)
        
        spriteNode.position = CGPoint(x: image.x + image.width/2, y: (Int(image.level.heightInPixels) - image.y) - image.height/2)
        spriteNode.isHidden = !image.visible
        spriteNode.alpha = image.opacity.cgFloatValue
        spriteNode.name = image.name
        
        spriteNode.apply(propertiesFrom: image)
        
        container.addChild(spriteNode)
    }
    
    public func add(objects: ObjectLayer, to container: Container) throws {
        let node = SKNode()
        container.addChild(node)

        node.name = objects.name
        node.isHidden = !objects.visible
        node.alpha = CGFloat(objects.opacity)
        node.apply(propertiesFrom: objects)
        
        for object in objects.objects {
            
            var node : SKNode? = nil
            
            if let elipse = object as? EllipseObject {
                let rect = CGRect(origin: .zero, size: CGSize(width: elipse.width.cgFloatValue, height: -elipse.height.cgFloatValue))

                let elipseNode = SKTKShapeNode(path: CGPath(ellipseIn: rect, transform: nil))
                
                elipseNode.position.x = elipse.x.cgFloatValue
                elipseNode.position.y = object.level.heightInPixels - elipse.y.cgFloatValue
                elipseNode.zRotation = -elipse.rotation.radians.cgFloatValue
                
                node = elipseNode
            } else if let tileObject = object as? TileObject {
                guard let tile = tileObject.level.tiles[tileObject.gid] else {
                    throw SKTiledKitError.tileNotFound
                }
                let cachedNode = SKTileSets.tileCache[tile.uuid]
                guard let tileNode = cachedNode?.copy() as? SKTKSpriteNode else {
                    throw SKTiledKitError.tileNodeDoesNotExist
                }
                
                let size = tileNode.calculateAccumulatedFrame().size
                
                tileNode.anchorPoint = .zero
                tileNode.position.x = tileObject.x.cgFloatValue
                tileNode.position.y = tileObject.level.heightInPixels - tileObject.y.cgFloatValue
                tileNode.zRotation = -tileObject.rotation.cgFloatValue.radians
                tileNode.xScale = tileObject.width.cgFloatValue / size.width
                tileNode.yScale = tileObject.height.cgFloatValue / size.height
                
                node = tileNode
                
            } else if let textObject = object as? TextObject {
                let rect = CGRect(origin: .zero, size: CGSize(width: textObject.width.cgFloatValue, height: -textObject.height.cgFloatValue))
                let textNode = SKTKTextNode(path: CGPath(rect: rect, transform: nil))

                textNode.add(textObject.string, applying: textObject.style)
                if object.showTextNodePath == true {
                    textNode.strokeColor = SKColor.white
                }
                
                textNode.position.x = textObject.x.cgFloatValue
                textNode.position.y = object.level.heightInPixels - textObject.y.cgFloatValue
                textNode.zRotation = -textObject.rotation.radians.cgFloatValue

                node = textNode
            } else if let rectangle = object as? RectangleObject {
                let rect = CGRect(origin: .zero, size: CGSize(width: rectangle.width.cgFloatValue, height: -rectangle.height.cgFloatValue))
                let rectangleNode = SKTKShapeNode(path: CGPath(rect: rect, transform: nil))

                rectangleNode.position.x = rectangle.x.cgFloatValue
                rectangleNode.position.y = object.level.heightInPixels - rectangle.y.cgFloatValue
                rectangleNode.zRotation = -rectangle.rotation.radians.cgFloatValue

                node = rectangleNode
            } else if let point = object as? PointObject {
                let pointNode = SKTKShapeNode(circleOfRadius: 1)
                
                pointNode.position.x = point.x.cgFloatValue
                pointNode.position.y = object.level.heightInPixels - point.y.cgFloatValue
                
                node = pointNode
            }
            
            if let node = node {
                node.name = object.name
                node.isHidden = !object.visible
                node.apply(propertiesFrom: object)
                
                container.addChild(node)
            }
            
        }
    }
    
}
