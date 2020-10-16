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

#warning("API: Promote to TiledKit")
public struct TiledType : OptionSet {
    public let rawValue : Int
    
    public init(rawValue:Int){
        self.rawValue = rawValue
    }
    
    public static let map                       = TiledType(rawValue: 1 << 0)
    public static let tileLayer                 = TiledType(rawValue: 1 << 1)
    public static let imageLayer                = TiledType(rawValue: 1 << 2)
    public static let groupLayer                = TiledType(rawValue: 1 << 3)
    public static let objectLayer               = TiledType(rawValue: 1 << 4)
    public static let pointObject               = TiledType(rawValue: 1 << 5)
    public static let rectangleObject           = TiledType(rawValue: 1 << 6)
    public static let ellipseObject             = TiledType(rawValue: 1 << 7)
    public static let polylineObject            = TiledType(rawValue: 1 << 8)
    public static let polygonObject             = TiledType(rawValue: 1 << 9)
    public static let tileObject                = TiledType(rawValue: 1 << 10)
    public static let textObject                = TiledType(rawValue: 1 << 11)
    public static let tile                      = TiledType(rawValue: 1 << 12)

    public static let anyLayer : TiledType     = [
        .tileLayer, .imageLayer, .groupLayer, .objectLayer
    ]
    
    public static let anyObject : TiledType    = [
        .pointObject, .rectangleObject, ellipseObject, .polylineObject, .polygonObject, .tileObject, .textObject
    ]

    public static let anyShape : TiledType    = [
        .rectangleObject, ellipseObject, .polylineObject, .polygonObject
    ]
}

public extension Propertied {
    func `is`(a type:TiledType)->Bool{
        return type.contains(tiledType)
    }
    
    var tiledType : TiledType {
        if let object = self as? Object {
            switch object.kind {
            case.point:
                return .pointObject
            case .rectangle:
                return .rectangleObject
            case .ellipse:
                return .ellipseObject
            case .polyline:
                return .polylineObject
            case .polygon:
                return .polygonObject
            case .text:
                return .textObject
            case .tile:
                return .tileObject
            }
        } else if let layer = self as? Layer {
            switch layer.kind {
            case .group:
                return .groupLayer
            case .image:
                return .imageLayer
            case .tile:
                return .tileLayer
            case .objects:
                return .objectLayer
            }
        } else if self is Map {
            return .map
        } else if self is Tile {
            return .tile
        } else {
            return []
        }
    }
}
