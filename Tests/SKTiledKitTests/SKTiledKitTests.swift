import XCTest

import TiledKit
import SpriteKit
@testable import SKTiledKit

final class SKTiledKitTests : XCTestCase {
    lazy var moduleBundleProject : Project = {
        Project(using: Bundle.module)
    }()
    
    func testResources() {
        XCTAssertNotNil(Bundle.module.path(forResource: "Test Map 1", ofType: "tmx", inDirectory: "Maps"))
    }
    
    func testSceneCreation(){
        do {
            let scene = try moduleBundleProject.retrieve(asType: SKTKScene.self, from: moduleBundleProject.url(for: "Test Map 1", in: "Maps", of: .tmx)!)
            
            let view = SKView(frame: NSRect(x: 0, y: 0, width: scene.size.width, height: scene.size.height))
            view.presentScene(scene)
            print(scene)
        } catch {
            XCTFail("Could not create scene \(error)")
        }
    }

    func testTranslation(){
        do {
            let scene = try moduleBundleProject.retrieve(asType: SKTKScene.self, from: moduleBundleProject.url(for: "Simple Map", in: "Maps", of: .tmx)!)

            let view = SKView(frame: NSRect(x: 0, y: 0, width: scene.size.width, height: scene.size.height))
            view.presentScene(scene)
            
            print(scene)
        } catch {
            XCTFail("Could not create scene \(error)")
        }
    }
    
    func testReadyPlayerOne(){
        do {
            
            let view = SKView(frame: NSRect(x: 0, y: 0, width: 160, height: 160))
            let scene = try moduleBundleProject.retrieve(asType: SKTKScene.self, from: moduleBundleProject.url(for: "Ready Player 1", in: "Maps", of: .tmx)!)
            view.presentScene(scene)
            
            print(scene)
        
        } catch {
            XCTFail("Could not create scene \(error)")
        }
    }

    func testValidUrlEncoding(){
        guard let imageUrl = moduleBundleProject.url(for: "4 Tiles", in: "Images", of: .png) else {
            XCTFail("Could not create image URL")
            return
        }
        let tile = Tile(imageUrl, bounds: PixelBounds(origin: .zero, size: Dimension(width:32,height:32)))
        
        let cachingUrl = tile.cachingUrl
        
        XCTAssertEqual(cachingUrl.absoluteString, "tkrc:///TileNode////Users/nhughes/Library/Developer/Xcode/DerivedData/SKTiledKit-ewgphuzitggjojazxlxlcnrlxdfh/Build/Products/Debug/SKTiledKitTests.xctest/Contents/Resources/SKTiledKit_SKTiledKitTests.bundle/Contents/Resources/Images/4%20Tiles.png/0/0/32/32")
    }
    static var allTests = [
        ("testResources", testResources),
    ]
}
