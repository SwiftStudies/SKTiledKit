import XCTest

@testable import TiledKit
import SpriteKit
@testable import SKTiledKit

#warning("Temporary Solution until https://bugs.swift.org/browse/SR-13714 is fixed and I can reference TiledResources from here")
enum Projects {
    case genericTiled
    
    var url : URL {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent(".build/checkouts/TiledResources/Sources/TiledResources")
        switch self {
        case .genericTiled:
            return root.appendingPathComponent("Generic Tiled Project/")
        }
    }
}

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
    
    func testStandardProducers(){
        SpriteKitEngine.registerProducers()
        XCTAssertEqual(SpriteKitEngine.engineMapPostProcessors().count, 3)
        XCTAssertEqual(SpriteKitEngine.engineMapFactories().count, 0)
        XCTAssertEqual(SpriteKitEngine.tileFactories().count, 0)
        XCTAssertEqual(SpriteKitEngine.engineTilePostProcessors().count, 0)
        XCTAssertEqual(SpriteKitEngine.layerFactories().count, 0)
        XCTAssertEqual(SpriteKitEngine.engineLayerPostProcessors().count, 2)
        XCTAssertEqual(SpriteKitEngine.tileFactories().count, 0)
        XCTAssertEqual(SpriteKitEngine.engineTilePostProcessors().count, 0)
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
    
    func testIsometric(){
        do {
            let project = Project(at: Projects.genericTiled.url)
            let view = SKView(frame: NSRect(x: 0, y: 0, width: 160, height: 160))

            let scene = try project.retrieve(SpriteKitEngine.self, mapNamed: "Isometric", in: "Maps")

            view.presentScene(scene)

        } catch {
            return XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testPhysicsProperties(){
        XCTFail("Needs reimplementing")
//        let propertyProcessor = PhysicsPropertiesPostProcessor()
//
//        let testProperties : Properties = [
//            PhysicalObjectProperty.affectedByGravity.tiledName : .bool(false),
//            PhysicalObjectProperty.physicsCategory.tiledName : .int(1),
//            PhysicalObjectProperty.mass.tiledName : .double(10)
//        ]
//        let sprite = SKSpriteNode()
//        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 10000)
//
//        XCTAssertEqual(sprite.physicsBody!.affectedByGravity, true)
//        XCTAssertEqual(sprite.physicsBody!.categoryBitMask, UInt32.max)
//        XCTAssertNotEqual(sprite.physicsBody!.mass, 10)
////        propertyProcessor.process(sprite: sprite, from: <#T##ObjectProtocol#>, for: <#T##Map#>, from: moduleBundleProject)
//          XCTAssertEqual(sprite.physicsBody!.affectedByGravity, false)
//        XCTAssertEqual(sprite.physicsBody!.categoryBitMask, 1)
//        XCTAssertEqual(sprite.physicsBody!.mass, 10)
    }
    
    func testLitProperties(){
        XCTFail("Needs reimplementing")
//        let propertyProcessor = BridgedPropertyProcessor<SKSpriteNode>(with: LitSpriteProperty.allCases)
//
//        let testProperties : Properties = [
//            LitSpriteProperty.litByMask.tiledName : .int(1),
//            LitSpriteProperty.shadowedByMask.tiledName : .int(2),
//            LitSpriteProperty.castsShadowsByMask.tiledName : .int(4),
//        ]
//        let sprite = SKSpriteNode()
//
//        XCTAssertEqual(sprite.lightingBitMask, 0)
//        XCTAssertEqual(sprite.shadowedBitMask, 0)
//        XCTAssertEqual(sprite.shadowCastBitMask, 0)
//        XCTAssertNoThrow(try propertyProcessor.process(sprite, of: nil, with: testProperties))
//        XCTAssertEqual(sprite.lightingBitMask, 1)
//        XCTAssertEqual(sprite.shadowedBitMask, 2)
//        XCTAssertEqual(sprite.shadowCastBitMask, 4)
    }
    
    static var allTests = [
        ("testResources", testResources),
    ]
}
