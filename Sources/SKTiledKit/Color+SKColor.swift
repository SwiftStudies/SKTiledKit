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

public extension Color {
    var skColor : SKColor {
        let red = CGFloat(self.red) / 255
        let green = CGFloat(self.green) / 255
        let blue = CGFloat(self.blue) / 255
        let alpha = CGFloat(self.alpha) / 255
        
        #if os(macOS)
        return SKColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
        #else
        return SKColor(red: red, green: green, blue: blue, alpha: alpha)
        #endif
    }
}
