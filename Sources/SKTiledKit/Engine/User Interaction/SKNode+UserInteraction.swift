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

extension SKNode {
    
    func fireAction(_ key:String, targetting objectId:Int){
        guard let action = SpriteKitEngine.registeredActions[key] else {
            return SpriteKitEngine.warn("No action with key '\(key)' is registered")
        }
        
        if objectId == 0 {
            run(action, withKey: key)
        } else {
            guard let scene = scene else {
                return SpriteKitEngine.warn("No scene for interacted node")
            }
            
            guard let target = scene.child(withTiledObject: objectId) else {
                return SpriteKitEngine.warn("Cannot run \(key) because no node exists with tiled Id \(objectId)")
            }
            target.run(action, withKey: key)
        }

    }
    
    func interactionBegan(){
        guard interactionBeganActionKey != "" else {
            return
        }

        fireAction(interactionBeganActionKey, targetting: userInteractionTarget)
    }
    
    func interactionEnded(){
        guard interactionEndedActionKey != "" else {
            return
        }

        fireAction(interactionEndedActionKey, targetting: userInteractionTarget)
    }
    
    func interactionMoved(to sceneLocation:CGPoint){
        print(sceneLocation)
    }
}

#if os(iOS)
extension SKNode {
    override func touchesBegan(with event: NSEvent) {
        interactionBegan()
    }
    
    open override func touchesMoved(with event: NSEvent) {
        interactionMoved(to: event.location(in: self.scene!))
    }
    
    override func touchesEnded(with event: NSEvent) {
        interactionEnded()
    }
}
#endif

#if os(macOS)
extension SKNode {
    open override func mouseDown(with event: NSEvent) {
        interactionBegan()
    }
    
    open override func mouseDragged(with event: NSEvent) {
        #warning("Force unwrap")
        interactionMoved(to: event.location(in: self.scene!))
    }
    
    open override func mouseUp(with event: NSEvent) {
        interactionEnded()
    }
}
#endif
