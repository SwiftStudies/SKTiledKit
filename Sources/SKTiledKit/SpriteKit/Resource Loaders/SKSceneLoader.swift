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

enum SceneLoadingError : Error {
    case sceneCouldNotReturned
}

public struct SKSceneLoader : ResourceLoader {
    let project : Project
    
    public func retrieve<R>(asType: R.Type, from url: URL) throws -> R {
        let map = try project.retrieve(asType: Map.self, from: url)

        let scene = SKTKScene()
        
        try apply(map: map, to: scene)
        
        guard let generatedScene = scene as? R else {
            throw SceneLoadingError.sceneCouldNotReturned
        }
        
        return generatedScene
    }
    
    internal func configure(_ node:SKNode, for layer:Layer){
        node.name = layer.name
        node.isHidden = !layer.visible
        node.alpha = layer.opacity.cgFloatValue
        node.apply(propertiesFrom: layer)
        node.position = layer.position.cgPoint.transform()
    }
    
    internal func walk(_ layers:[Layer], in map:Map, with parent:SKNode) throws {
        for layer in layers {
            switch layer.kind {
            
            case .tile(_):
                <#code#>
            case .objects(_):
                <#code#>
            case .group(let group):
                let node = SKTKNode()
                configure(node, for: layer)
                try walk(group.layers, in: map, with: node)
                parent.addChild(node)
            case .image(let image):
                let texture = try project.retrieve(textureFrom: image.source, filteringMode: layer.properties["filteringMode"])

                let spriteNode = SKTKSpriteNode(texture: texture)
                configure(spriteNode, for: layer)
                
                // Position has to be adjusted because it has a different anchor
                spriteNode.position = CGRect(origin: layer.position.cgPoint, size: image.size.cgSize).transform(with: spriteNode.anchorPoint).origin
                
                parent.addChild(spriteNode)
            }
        }
    }
    
    internal func apply(map : Map, to scene:SKScene) throws {
        scene.size = map.pixelSize.cgSize

        scene.userData = NSMutableDictionary()

        scene.apply(propertiesFrom: map)
        
        for tileSet in map.tileSets {
            
        }
        
        // Prepare the remaining layers
        try walk(map.layers, in: map, with: scene)
        
        // Add a camera to apply the transform to the level
        let camera = SKCameraNode()
        camera.position = CGPoint(x: scene.size.width/2, y: scene.size.height / -2)
        
        scene.addChild(camera)
        scene.camera = camera
    }
    
}
