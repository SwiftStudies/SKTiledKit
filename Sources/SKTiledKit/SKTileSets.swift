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

typealias TileUUID = String

internal extension TileSet.Tile {
    var uuid : Int {
        #warning("This is slow and has a forced unwrap")
        return "\(tileSet!.name)-\(identifier.hashValue)".hash
    }
}

internal class SKTileSets {
    static var tileTextureCache = [TileUUID:SKTexture]()
    static var tileCache = [Int:SKNode]()

    static private func load(texture url:URL) throws -> SKTexture {
        
        if let cachedTexture = tileTextureCache[url.path] {
            return cachedTexture
        }
        
        let provider : CGDataProvider
        
        if let directProvider = CGDataProvider(url: url as CFURL) {
            provider = directProvider
        } else {
            // See if it has been processed into directly into the bundle resources
            var bundleURL = Bundle.main.bundleURL
            bundleURL.appendPathComponent(url.lastPathComponent)
            guard let bundleProvider = CGDataProvider(url: bundleURL as CFURL) else {
                // Perhaps it's from a atlas
                return SKTexture(imageNamed: url.deletingPathExtension().lastPathComponent)
            }
            provider = bundleProvider
        }
        
        guard let cgImageSource = CGImageSourceCreateWithDataProvider(provider, nil) else {
            throw SKTiledKitError.couldNotLoadImage(url: url)
        }
        
        guard let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, nil) else {
            throw SKTiledKitError.couldNotCreateImage(url: url)
        }
            
            
        let loadedTexture = SKTexture(cgImage: cgImage)

        tileTextureCache[url.path] = loadedTexture
        
        return loadedTexture
    }

    fileprivate static func createTileNode(_ tile:TileSet.Tile, from tileset:TileSet, with texture:SKTexture) {
        #warning("Is not handling any layers on the tile")
        let node = SKSpriteNode(texture: texture)
        tileCache[tile.uuid] = node
    }
    
    static func load(_ tileset:TileSet) throws {
        switch tileset.type {
        case .files:
            for tile in tileset.tiles.values {
                guard let url = tile.path else {
                    throw SKTiledKitError.missingPathForTile(tile: "\(tileset.name) - \(tile.identifier)")
                }
                createTileNode(tile, from: tileset, with: try load(texture: url))
            }
        case .sheet(tileSheet: let tileSheet):
            let parentTexture = try load(texture: tileSheet.imagePath)
            for tile in tileset.tiles.values {
                guard let position = tile.position else {
                    throw SKTiledKitError.noPositionForTile(identifier: tile.identifier.hashValue, tileSet: tileset.name)
                }
                let subTexture = SKTexture(
                    rect: CGRect(x: position.x.cgFloatValue / parentTexture.size().width,
                                 y: position.y.cgFloatValue  / parentTexture.size().height,
                                 width: tileset.tileWidth.cgFloatValue  / parentTexture.size().width,
                                 height: tileset.tileHeight.cgFloatValue  / parentTexture.size().height),
                    in: parentTexture )
                createTileNode(tile, from: tileset, with: subTexture)
            }
            return
        }
    }
}
