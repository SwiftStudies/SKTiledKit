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

import SpriteKit
import TiledKit

extension SKScene {
    public func add(tileLayer: TileLayer, to container: Container) throws {
        
        let tileLayerNode = SKTKNode()
                
        tileLayerNode.name = tileLayer.name
        tileLayerNode.isHidden = !tileLayer.visible
        tileLayerNode.alpha = CGFloat(tileLayer.opacity)
        tileLayerNode.apply(propertiesFrom: tileLayer)
            
        for x in 0..<tileLayer.level.width {
            for y in 0..<tileLayer.level.height {

                let tileMapOffset = y*tileLayer.level.width+x
                let levelTileOffset = tileLayer.tiles[tileMapOffset]
                
                if levelTileOffset > 0 {
                    guard let tile = tileLayer.level.tiles[levelTileOffset] else {
                        throw SKTiledKitError.tileNotFound
                    }
                    
                    guard let tileSet = tile.tileSet else {
                        throw SKTiledKitError.tileHasNoTileSet(tile:tile)
                    }

                    let cachedNode = SKTileSets.tileCache[tile.uuid]
                    guard let tileNode = cachedNode?.copy() as? SKSpriteNode else {
                        throw SKTiledKitError.tileNodeDoesNotExist
                    }
                    
                    tileNode.position = CGRect(x: x * tileLayer.level.tileWidth, y: y * tileLayer.level.tileHeight, width: tileLayer.level.tileWidth, height: tileLayer.level.tileHeight).transform(with: tileNode.anchorPoint).origin
                    
                    tileLayerNode.addChild(tileNode)
                }
            }
        }
        
        container.addChild(tileLayerNode)
    }
}
