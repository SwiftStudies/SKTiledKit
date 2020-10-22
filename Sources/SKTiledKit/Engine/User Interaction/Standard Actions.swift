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

internal extension SpriteKitEngine {
    static func registerStandardActions(){
        let impulseMagnitude = 3
        
        registerAction(key: "impulseUp", action: SKAction.applyImpulse(CGVector(dx: 0, dy: -impulseMagnitude), duration: 0.2))
        registerAction(key: "impulseDown", action: SKAction.applyImpulse(CGVector(dx: 0, dy: impulseMagnitude), duration: 0.2))
        registerAction(key: "impulseLeft", action: SKAction.applyImpulse(CGVector(dx: -impulseMagnitude, dy: 0), duration: 0.2))
        registerAction(key: "impulseRight", action: SKAction.applyImpulse(CGVector(dx: impulseMagnitude, dy: 0), duration: 0.2))
    }
}
