#  SKTiledKit Documentation

## Introduction
The philosophy of SKTiledKit is inherited from TiledKit... make the default behaviour right 90% of the time, make it easy to change it if required. 

This is expressed in a number of ways: 

 - If you just create a Tiled level, and load it into a SpriteKit scene, it will look as close to "the same" as it did in Tiled as possible. 
 - If you use the predefined SpriteKit Tiled object types, you should be able to get very close to a functioning level (for example, physics and cameras)
 - Further specialization for _your_ game can be done with Factories and Processors
 
In general, the right place to start is very simple. Assuming you have your resources (you actually don't need to create a Tiled project, the code below will assume that your default resource bundle for your target) it will just be assumed that a project, with the different folders that exist in the bundle is there.

    // The the map from the Maps folder of the app's bundle
    let scene = try Project.default.retrieve(scene: "Level 1", in: "Maps")

    // Configure and present the view
    scene.scaleMode = .aspectFill
    let view  = SKView(frame: scene.frame)
    view.presentScene(scene)

The remainder of the documentation is organized around the three approaches described above.

## Testing SKTiledKit within Tiled

Please read the instructions on [`sk-tiled`](sk-tiled.md) to understand how to set up a keyboard shortcut to directly run any Tiled level in SKTiledKit. 

## Default Interpretation of Tiled entities

The pages below will confirm what is, and isn't supported from Tiled. Almost everything is supported with few exceptions (for example setting underline style for text), but any gaps are made clear in these pages. They capture the default behaviour for SKTiledKit, or rather what you get for free out of the box.

 - [Maps](Maps.md)
 - [Tile Sets](Tile%20Sets.md)
 - [Layers](Layers.md)
 - [Objects](Objects.md)
 - [Properties](Properties.md)
 
 ## Using SKTiledKit Object Types in Tiled
 
  - [SKSprite](SKSprite.md)
  - [SKShape](SKShape.md)
  - [SKEdgeLoop](SKEdgeLoop.md)
  - [SKCamera](SKCamera.md)
  - [SKLight](SKLight.md)
  - [SKUserInterface](SKUserInterface.md)
  - SKEmitter _Not yet implemented_
 
 ## Specializing for your game
 
  - Understanding Factories and Processors _To Do_
  - Best practice - Developing your own factory _To Do_
  - Best practice - Developing your own processors _To Do_
 
