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
    typealias TileLayerType = SKNode
    typealias GroupLayerType = SKNode
    typealias ObjectLayerType = SKNode

    fileprivate static func configure(_ node:SKNode, for layer:LayerProtocol){
        node.name = layer.name
        node.isHidden = !layer.visible
        node.alpha = layer.opacity.cgFloatValue
        node.apply(propertiesFrom: layer)
        node.position = layer.position.cgPoint.transform()
    }
    
    static func make(spriteFrom texture: SKTexture, for layer: LayerProtocol, in map: Map, from project: Project) throws -> SKSpriteNode? {

        texture.filteringMode = layer.properties["filteringMode"] == "nearest" ? .nearest : .linear

        let spriteNode = SKSpriteNode(texture: texture)
        configure(spriteNode, for: layer)
        
        // Position has to be adjusted because it has a different anchor
        // THIS WAS image.size (from the imageRef) which is no longer passed
        // make sure this is covered by testing
        spriteNode.position = CGRect(origin: layer.position.cgPoint, size: texture.size()).transform(with: spriteNode.anchorPoint).origin
        
        return spriteNode
    }
    
    static func make(objectContainerFrom  layer: LayerProtocol, in map: Map, from project: Project) throws -> SKNode? {
        let layerNode = SKNode()
        configure(layerNode, for: layer)
        
        return layerNode
    }
    
    static func make(groupFrom layer: LayerProtocol, in map: Map, from project: Project) throws -> SKNode? {
        let layerNode = SKNode()
        configure(layerNode, for: layer)
        
        return layerNode
    }
    
    static func make(tileLayer tileGrid: TileGrid, for layer: LayerProtocol, with sprites: MapTiles<SpriteKitEngine>, in map: Map, from project: Project) throws -> SKNode? {
        let tileLayerNode = SKNode()
        configure(tileLayerNode, for: layer)
        
        for x in 0..<tileGrid.size.width {
            for y in 0..<tileGrid.size.height {
                let tileGid = tileGrid[x,y]
                
                if tileGid.globalTileOffset > 0 {
                    // TileSets were pre-loaded by the map before we got here
                    guard let tileNode = sprites[tileGid] else {
                        throw SKTiledKitError.tileNotFound
                    }

                    tileNode.position = CGRect(x: x * map.tileSize.width, y: y * map.tileSize.height, width: map.tileSize.width, height: map.tileSize.height).transform(with: tileNode.anchorPoint).origin
                    
                    tileLayerNode.addChild(tileNode)
                }
            }
        }
        return tileLayerNode
    }
    
}
