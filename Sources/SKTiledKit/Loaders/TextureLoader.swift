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

extension Project {
    internal func retrieve(textureFrom url:URL, filteringMode:PropertyValue?) throws -> SKTexture {
        let texture = try retrieve(asType: SKTexture.self, from: url)
        
        if filteringMode == "nearest" {
            texture.filteringMode = .nearest
        }
        
        return texture
    }
}

public struct TextureLoader : ResourceLoader {
    let     project : Project
    
    public func retrieve<R>(asType: R.Type, from url: URL) throws -> R where R : Loadable {
        let provider : CGDataProvider
        
        if let directProvider = CGDataProvider(url: url as CFURL) {
            provider = directProvider
        } else {
            // See if it has been processed into directly into the bundle resources
            var bundleURL = Bundle.main.bundleURL
            bundleURL.appendPathComponent(url.lastPathComponent)
            guard let bundleProvider = CGDataProvider(url: bundleURL as CFURL) else {
                // Perhaps it's from a atlas
                guard let loadedResource = SKTexture(imageNamed: url.deletingPathExtension().lastPathComponent) as? R else {
                    throw SceneLoadingError.textureCouldNotBeReturned
                }
                
                return loadedResource
            }
            provider = bundleProvider
        }
        
        guard let cgImageSource = CGImageSourceCreateWithDataProvider(provider, nil) else {
            throw SKTiledKitError.couldNotLoadImage(url: url)
        }
        
        guard let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, nil) else {
            throw SKTiledKitError.couldNotCreateImage(url: url)
        }
            
            
        let texture = SKTexture(cgImage: cgImage)

        guard let loadedResource = texture as? R else {
            throw SceneLoadingError.textureCouldNotBeReturned
        }
        
        return loadedResource
    }
    
}

extension SKTexture : Loadable {
    public static func loader(for project: Project) -> ResourceLoader {
        return TextureLoader(project: project)
    }
    
    public var cache: Bool {
        true
    }
    
    public func newInstance() -> Self {
        return self
    }
}
