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


public protocol PostProcessor {
    
}

public protocol MapPostProcessor : PostProcessor {
    func process(_ scene:SKScene, for map:Map, from project:Project) throws ->SKScene
}

public protocol LayerPostProcessor : PostProcessor {
    func process(_ node:SKNode,for layer:Layer, in map:Map, from project:Project) throws ->SKNode
}

public protocol ObjectPostProcessor : PostProcessor {
    func process(_ node:SKNode, of type:String?, with properties:Properties) throws -> SKNode
    func process(_ node:SKNode,for object:Object, in layer:Layer, and map:Map, from project:Project) throws ->SKNode
}

public protocol TileProcessor : PostProcessor {
    func process(_ sprite:SKSpriteNode, for tile:Tile, in tileset:TileSet, from project:Project) throws ->SKSpriteNode
}

public protocol TextureProcessor : PostProcessor {
    func process(_ texture:SKTexture, for tile:Tile, in tileset:TileSet, from project:Project) throws ->SKTexture
}


