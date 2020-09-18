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

extension SKScene : SpecializedLevel {
    public typealias Container = SKNode
    
    public var primaryContainer: Container {
        return self
    }

    public func apply(tiledLevel level: Level) {
        scene?.size =  CGSize(width: CGFloat(level.width*level.tileWidth), height: CGFloat(level.height*level.tileHeight))
    }
    public func create(tileSet: TileSet) throws {
        try SKTileSets.load(tileSet)        
    }
    
    #warning("This may not be necessary")
    public func add(tile: Int, to tileSet: TileSet) throws {
        throw SKTiledKitError.notImplemented
    }
    
    public func add(tileLayer: TileLayer, to container: Container) throws {
        
        let tileLayerNode = SKNode()
                
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
                    tileNode.position = CGPoint(x: x * tileLayer.level.tileWidth + (tile.tileSet!.tileWidth / 2), y: y * tileLayer.level.tileHeight + (tile.tileSet!.tileHeight / 2))
                    tileLayerNode.addChild(tileNode)
                }
            }
        }
        
        container.addChild(tileLayerNode)
    }
    
    public func add(group: GroupLayer, to container: Container) throws -> Container {
        let node = SKNode()
        
        container.addChild(node)
        
        return container
    }

    #warning("Not implemented")
    public func add(image: ImageLayer, to container: Container) throws {
        let emptyTextureNode = SKTexture()
        
        let spriteNode = SKSpriteNode(texture: emptyTextureNode, color: SKColor.red, size: CGSize(width: 100, height: 100))
        
        spriteNode.position = CGPoint(x: image.x, y: image.y)
        
//        container.addChild(spriteNode)
    }
    
    public func add(objects: ObjectLayer, to container: Container) throws {
        for object in objects.objects {
            if let rectangle = object as? EllipseObject {
                let elipse = SKShapeNode(ellipseIn: CGRect(x: rectangle.x.cgFloatValue, y: rectangle.y.cgFloatValue, width: rectangle.width.cgFloatValue, height: rectangle.height.cgFloatValue))
                container.addChild(elipse)
            } else if let rectangle = object as? RectangleObject {
                let rectangle = SKShapeNode(rect: CGRect(x: rectangle.x.cgFloatValue, y: rectangle.y.cgFloatValue, width: rectangle.width.cgFloatValue, height: rectangle.height.cgFloatValue))
                container.addChild(rectangle)
            }
        }
    }
    
}
