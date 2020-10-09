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

extension Point where N == Int {
    var cgPoint : CGPoint {
        return CGPoint(x: x, y: y)
    }
}

extension Point where N == Double {
    var cgPoint : CGPoint {
        return CGPoint(x: x, y: y)
    }
}


extension Point where N == UInt32 {
    var cgPoint : CGPoint {
        return CGPoint(x: Int(x), y: Int(y))
    }
}

extension TiledKit.Dimension where N == Int {
    var cgSize : CGSize {
        return CGSize(width: width, height: height)
    }
}

extension TiledKit.Dimension where N == Double {
    var cgSize : CGSize {
        return CGSize(width: width, height: height)
    }
}


extension TiledKit.Dimension where N == UInt32 {
    var cgSize : CGSize {
        return CGSize(width: Int(width), height: Int(height))
    }
}

extension Rectangle where N == Int {
    var cgRect : CGRect {
        return CGRect(origin: origin.cgPoint, size: size.cgSize)
    }
}

extension Rectangle where N == Double {
    var cgRect : CGRect {
        return CGRect(origin: origin.cgPoint, size: size.cgSize)
    }
}


extension Rectangle where N == UInt32 {
    var cgRect : CGRect {
        return CGRect(origin: origin.cgPoint, size: size.cgSize)
    }
}

extension CGFloat : ExpressibleAsTiledFloat {
    public static func instance(bridging value: Double) -> CGFloat {
        return CGFloat(value)
    }
}

extension BinaryFloatingPoint {
    var cgFloatValue : CGFloat {
        return CGFloat(self)
    }
    
    var radians : Self {
        let degree = Self.pi / 180
        return self * degree
    }

    var degrees : Self {
        let radian = 180 / Self.pi
        return self * radian
    }
    
    var dobuleValue : Double {
        return Double(self)
    }
    
    var intValue : Int {
        return Int(self)
    }

}

extension BinaryInteger {
    var cgFloatValue : CGFloat {
        return CGFloat(self)
    }
    var dobuleValue : Double {
        return Double(self)
    }
}
