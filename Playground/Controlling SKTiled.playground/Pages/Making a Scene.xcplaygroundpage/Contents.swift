//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import TiledKit
import SKTiledKit



let project = Project(at: Bundle.main.url(forResource: "Tiled Project", withExtension: nil)!)

do {
    let scene = try project.retrieve(scene: "Level 1", in: "Maps")
    scene.scaleMode = .aspectFill
    let view  = SKView(frame: scene.frame)
    view.presentScene(scene)
    
    PlaygroundSupport.PlaygroundPage.current.liveView = view
} catch {
    print("Something went wrong :-/ \(error)")
}

