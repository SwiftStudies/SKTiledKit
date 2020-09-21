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

extension SKScene{
    public func add(image: ImageLayer, to container: Container) throws {
        let texture = try SKTileSets.load(texture: image.url)
        
        let spriteNode = SKTKSpriteNode(texture: texture)
        
        spriteNode.position = CGRect(x: image.x, y: image.y, width: image.width, height: image.height).transform(with: spriteNode.anchorPoint).origin
        spriteNode.isHidden = !image.visible
        spriteNode.alpha = image.opacity.cgFloatValue
        spriteNode.name = image.name
        
        spriteNode.apply(propertiesFrom: image)
        
        container.addChild(spriteNode)
    }
    
}
