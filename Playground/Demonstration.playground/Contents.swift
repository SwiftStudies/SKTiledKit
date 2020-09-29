//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import TiledKit
import SKTiledKit

print("Starting")

do {
    guard let levelOneUrl = Project.default.url(for: "Level 1", in: "Maps", of: .tmx) else {
        fatalError("Can't find the map :-/")
    }
    let scene = try Project.default.retrieve(asType: SKTKScene.self, from: levelOneUrl)
    scene.scaleMode = .aspectFill
    
    let view = SKView(frame: scene.frame)
    view.presentScene(scene)

    PlaygroundSupport.PlaygroundPage.current.liveView = view
} catch {
    print("Something went wrong: \(error)")
}

print("Done")

