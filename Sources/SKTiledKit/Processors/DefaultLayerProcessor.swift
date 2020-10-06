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

public struct DefaultLayerProcessor : LayerProcessor {
    internal func configure(_ node:SKNode, for layer:Layer){
        node.name = layer.name
        node.isHidden = !layer.visible
        node.alpha = layer.opacity.cgFloatValue
        node.apply(propertiesFrom: layer)
        node.position = layer.position.cgPoint.transform()
    }
    
    public func willCreate(nodeFor layer: Layer, in map: Map, from project: Project, with walker:MapWalker) throws -> SKNode? {
        var layerNode : SKNode?

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

            try walker.walk(objects, from: layer, to: objectLayerNode, in: map)
            
            layerNode = objectLayerNode
        case .group(let group):
            let node = SKNode()
            configure(node, for: layer)
            try walker.walk(group.layers, in: map, with: node)
            
            layerNode = node
        case .image(let image):
            let texture = try project.retrieve(textureFrom: image.source, filteringMode: layer.properties["filteringMode"])

            let spriteNode = SKSpriteNode(texture: texture)
            configure(spriteNode, for: layer)
            
            // Position has to be adjusted because it has a different anchor
            spriteNode.position = CGRect(origin: layer.position.cgPoint, size: image.size.cgSize).transform(with: spriteNode.anchorPoint).origin
            
            
            layerNode = spriteNode
        }

        return layerNode
    }
    
    public func didCreate(_ node: SKNode, for layer: Layer, in map: Map, from project: Project, with walker:MapWalker) throws -> SKNode {
        return node
    }
    
    
}
