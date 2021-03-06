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
        node.userData = NSMutableDictionary()
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
    
    static func make(tileLayer layer: LayerProtocol, with sprites: MapTiles<SpriteKitEngine>, in map: Map, from project: Project) throws -> SKNode? {
        let tileLayerNode = SKNode()
        configure(tileLayerNode, for: layer)
        
        return tileLayerNode
    }
    
    static func make(tileWith tile: SKSpriteNode, at position: Position, orientation flip: TileFlip, for tileLayer: LayerProtocol, in map: Map, from project: Project) throws -> SKSpriteNode {
                
        if flip.contains(.diagonally){
            tile.zRotation += CGFloat.pi / 2
            switch (flip.contains(.horizontally), flip.contains(.vertically)){
            case (false,false): 
                tile.xScale *= -1                
            case (false, true): break
            case (true,false): 
                tile.xScale *= -1
                tile.yScale *= -1
            case (true,true): 
                tile.yScale *= -1
            }
        } else {
            if flip.contains(.horizontally){
                tile.xScale *= -1
            }

            if flip.contains(.vertically){
                tile.yScale *= -1
            }            
        }
        
        tile.position = CGRect(origin: position.cgPoint, size: map.tileSize.cgSize).transform(with: tile.anchorPoint).origin

        
        return tile
    }
}
