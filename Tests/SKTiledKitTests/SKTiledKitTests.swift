import XCTest

@testable import TiledKit
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
            let view = SKView(frame: NSRect(x: 0, y: 0, width: 160, height: 160))

            let scene : SKScene = try
                moduleBundleProject.retrieve(SpriteKitEngine.self, mapNamed: "Test Map 1", in: "Maps")
                        
            view.presentScene(scene)
            print(scene)
        } catch {
            XCTFail("Could not create scene \(error)")
        }
    }

    func testTranslation(){
        do {
            let scene = try moduleBundleProject.retrieve(asType: SKScene.self, from: moduleBundleProject.url(for: "Simple Map", in: "Maps", of: .tmx)!)

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
            let scene = try moduleBundleProject.retrieve(asType: SKScene.self, from: moduleBundleProject.url(for: "Ready Player 1", in: "Maps", of: .tmx)!)
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
    
    func testPhysicsProperties(){
        let propertyProcessor = PhysicsPropertiesPostProcessor()

        let testProperties : Properties = [
            PhysicalObjectProperty.affectedByGravity.tiledPropertyName : .bool(false),
            PhysicalObjectProperty.physicsCategory.tiledPropertyName : .int(1),
            PhysicalObjectProperty.mass.tiledPropertyName : .double(10)
        ]
        let sprite = SKSpriteNode()
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 10000)
        
        XCTAssertEqual(sprite.physicsBody!.affectedByGravity, true)
        XCTAssertEqual(sprite.physicsBody!.categoryBitMask, UInt32.max)
        XCTAssertNotEqual(sprite.physicsBody!.mass, 10)
        XCTAssertNoThrow(try propertyProcessor.process(sprite, of: nil, with: testProperties))
        XCTAssertEqual(sprite.physicsBody!.affectedByGravity, false)
        XCTAssertEqual(sprite.physicsBody!.categoryBitMask, 1)
        XCTAssertEqual(sprite.physicsBody!.mass, 10)
    }
    
    func testLitProperties(){
        let propertyProcessor = PropertyPostProcessor<SKSpriteNode>(with: LitSpriteProperty.allCases)

        let testProperties : Properties = [
            LitSpriteProperty.litByMask.tiledPropertyName : .int(1),
            LitSpriteProperty.shadowedByMask.tiledPropertyName : .int(2),
            LitSpriteProperty.castsShadowsByMask.tiledPropertyName : .int(4),
        ]
        let sprite = SKSpriteNode()
        
        XCTAssertEqual(sprite.lightingBitMask, 0)
        XCTAssertEqual(sprite.shadowedBitMask, 0)
        XCTAssertEqual(sprite.shadowCastBitMask, 0)
        XCTAssertNoThrow(try propertyProcessor.process(sprite, of: nil, with: testProperties))
        XCTAssertEqual(sprite.lightingBitMask, 1)
        XCTAssertEqual(sprite.shadowedBitMask, 2)
        XCTAssertEqual(sprite.shadowCastBitMask, 4)
    }
    
    static var allTests = [
        ("testResources", testResources),
    ]
}
