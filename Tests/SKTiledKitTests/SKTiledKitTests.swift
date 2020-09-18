import XCTest

import TiledKit
import SpriteKit
@testable import SKTiledKit

final class SKTiledKitTests : XCTestCase {
    func testResources() {
        XCTAssertNotNil(Bundle.module.path(forResource: "Test Map 1", ofType: "tmx", inDirectory: "Maps"))
    }
    
    func testSceneCreation(){
        guard let url = Bundle.module.url(forResource: "Test Map 1", withExtension: "tmx", subdirectory: "Maps") else {
            XCTFail("Failed to load the map")
            return
        }
        
        do {
            let scene = try SKScene(tiledLevel: url)
            
            let view = SKView(frame: NSRect(x: 0, y: 0, width: scene.size.width, height: scene.size.height))
            view.presentScene(scene)
            print(scene)
        } catch {
            XCTFail("Could not create scene \(error)")
        }
    }
    
    static var allTests = [
        ("testResources", testResources),
    ]
}
