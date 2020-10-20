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
    typealias TextureType = SKTexture

    fileprivate static func scale(_ bounds:CGRect, to texture: SKTexture) -> CGRect {
        return CGRect(x: bounds.origin.x / texture.size().width,
                      y: bounds.origin.y / texture.size().height,
                      width: bounds.size.width / texture.size().width,
                      height: bounds.size.height / texture.size().height)
    }
    
    static func make(texture: SKTexture, with bounds: PixelBounds?, and properties: Properties, in project: Project) throws -> SKTexture {

        var texture = texture
        if let bounds = bounds, bounds.size.cgSize != texture.size() {
            var textureBounds = scale(bounds.cgRect, to: texture)
            textureBounds.origin.y = (1 - textureBounds.origin.y) - textureBounds.size.height
            texture = SKTexture(rect: textureBounds, in: texture)
        }
        
        if let filteringMode = properties["filteringMode"], filteringMode == "nearest" {
            texture.filteringMode = .nearest
        }
        
        return texture
    }
    
    public static func load<LoaderType>(textureFrom url: URL, by loader: LoaderType) throws -> SKTexture where LoaderType : EngineImageLoader {
        
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
            
            
        return SKTexture(cgImage: cgImage)
    }
}
