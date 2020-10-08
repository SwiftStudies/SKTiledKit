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

public struct StandardTexturePlant : TextureFactory, TextureProcessor {
    private func scale(_ bounds:CGRect, to texture: SKTexture) -> CGRect {
        return CGRect(x: bounds.origin.x / texture.size().width,
                      y: bounds.origin.y / texture.size().height,
                      width: bounds.size.width / texture.size().width,
                      height: bounds.size.height / texture.size().height)
    }
    
    public func process(_ texture: SKTexture, applying properties:Properties, from project: Project) -> SKTexture {
        
        if let filteringMode = properties["filteringMode"], filteringMode == "nearest" {
            texture.filteringMode = .nearest
        }

        return texture
    }
    
    public func make(textureFor imageUrl: URL, with frame: Rectangle<Int>, from project: Project) throws -> SKTexture? {
        let texture = try project.retrieve(asType: SKTexture.self, from: imageUrl)
        
        if texture.size() != frame.cgRect.size {
            var textureBounds = scale(frame.cgRect, to: texture)
            textureBounds.origin.y = (1 - textureBounds.origin.y) - textureBounds.size.height
            return SKTexture(rect: textureBounds, in: texture)
        }
        
        return texture
    }
    
    
}
