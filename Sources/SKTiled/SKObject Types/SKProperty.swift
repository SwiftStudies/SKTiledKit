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
import Foundation

enum SKProperty : String {
    case strokeColor, fillColor, trackObject
    case physicsCategory, physicsCollisionMask, physicsContactMask, physicsPreciseCollisions
    case affectedByGravity, allowsRotation, isDynamic, mass, friction, restitution, linearDamping, angularDamping
    case litByMask, shadowedByMask, castsShadowsByMask, normalImage
    case lightCategory, ambientColor, lightColor, shadowColor, falloff, direction
    
    var propertyName : String {
        switch self {
        default:
            return rawValue
        }
    }
    
    private static var values : [SKProperty : PropertyValue] = [
        .strokeColor : .color(Color.white),
        .fillColor   : .color(Color.clear),
        .trackObject : .object(id: 0),
        .physicsCategory : 0,
        .physicsContactMask : 0,
        .physicsCollisionMask : 0,
        .physicsPreciseCollisions : .bool(false),
        .litByMask : 0,
        .shadowedByMask : 0,
        .castsShadowsByMask : 0,
        .normalImage : .file(url: URL(fileURLWithPath: "normalTexture.png")),
        .lightCategory : 0,
        .ambientColor : .color(.white),
        .lightColor : .color(.white),
        .shadowColor : .color(.black),
        .falloff : 1.0,
        .direction : 360,
        .affectedByGravity : true,
        .allowsRotation : false,
        .isDynamic : false,
        .mass : -1.0,
        .friction : 0.2,
        .restitution : 0.2,
        .linearDamping : 0.1,
        .angularDamping : 0.1,
    ]
    
    var propertyValue : PropertyValue {
        return SKProperty.values[self]!
    }
}
