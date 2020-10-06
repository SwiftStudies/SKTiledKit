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

public protocol MapWalker {
    func walk(_ objects: [Object], from layer:Layer, to container: SKNode, in map:Map) throws
    func walk(_ layers:[Layer], in map:Map, with parent:SKNode) throws
}

public protocol TileProcessor {
    func willCreate(spriteFor tile:Tile, in tileset:TileSet, from project:Project)->SKSpriteNode?
    func didCreate(_ sprite:SKSpriteNode, for tile:Tile, in tileset:TileSet, from project:Project)->SKSpriteNode
}

public protocol MapProcessor {
    func willCreate(sceneFor map:Map, from project:Project) throws ->SKScene?
    func didCreate(_ scene:SKScene, for map:Map, from project:Project) throws ->SKScene
}

public protocol LayerProcessor {
    func willCreate(nodeFor layer:Layer, in map:Map, from project:Project, with walker:MapWalker) throws ->SKNode?
    func didCreate(_ node:SKNode,for layer:Layer, in map:Map, from project:Project, with walker:MapWalker) throws ->SKNode
}

public protocol ObjectProcessor {
    func willCreate(nodeFor object:Object,in layer:Layer, and map:Map, from project:Project) throws ->SKNode?
    func didCreate(_ node:SKNode,for object:Object, in layer:Layer, and map:Map, from project:Project) throws ->SKNode
}

