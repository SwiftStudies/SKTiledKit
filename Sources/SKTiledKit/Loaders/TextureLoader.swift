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
        throw SceneLoadingError.obsolete("TextureLoader.retrieve")
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
