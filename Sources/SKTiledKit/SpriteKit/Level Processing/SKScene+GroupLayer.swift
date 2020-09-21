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
    public func add(group: GroupLayer, to container: Container) throws -> Container {
        let node = SKTKNode()
        
        node.name = group.name
        node.isHidden = !group.visible
        node.alpha = CGFloat(group.opacity)
        node.apply(propertiesFrom: group)
        node.position = CGPoint(x: group.x, y: group.y).transform()
        
        container.addChild(node)
        
        return container
    }
}
