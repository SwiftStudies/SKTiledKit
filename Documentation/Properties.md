#  Properties

All types of properties are supported, but the following should be noted about some types 

 - __Object__ At the moment just the `id` of the object is captured (as an `Int`) in future methods may be added to build an index of these so that the resultant SpriteKit can be accessed directly
 - __Color__ When added to [`userData`](https://developer.apple.com/documentation/spritekit/sknode/1483121-userdata?language=swift) for a created node it will be converted into an [`SKColor`](https://developer.apple.com/documentation/spritekit/skcolor), if you are reading it directly at any point it is captured in a `TiledKit.Color` object, which has a `.skColor` property if you wish to manually convert it. 
 - __File__ These are just treated as `String`s with no special processing

## Property Categories

### <a id="node" />Node

Node properties apply to all objects

__Used by__ SKShape, SKLight, SKEdgeLoop, SKSprite  
 - `zPosition (Float, 0.0)` → `SKNode.zPosition` 
 Sets the zPosition in SpriteKit. 

### <a id="interactable" />Interactable 

Node properties apply to all objects

 - `userInteraction (Bool, false)` → `SKNode.isUserInteractionEnabled`   
 If set to to true interaction event will trigger the specified actions on the specified target.
 
 - `actionTarget (Object, 0)` → `SKNode.userData["actionTarget"] : Int`  
 The target of the action, by default if not set, or set to 0 the action will be run on the object itself (no target) 
 
 - `interactionBeganActionKey (String, "")` → `SKNode.userData["interactionBeganActionKey"] : String`   
 The action key (as registered with `SpriteKitEngine`) to run when the interaction begins. An interaction can be a touch or mouse click depending on the platform.
 
 - `interactionEndedActionKey (String, "")` → `SKNode.userData["interactionEndedActionKey"] : String`   
 The action key (as registered with `SpriteKitEngine`) to run when the interaction ends. An interaction can be a touch or mouse click depending on the platform.
 
### <a id="camera" />Camera

Camera properties apply to Rectangle objects (typically only one, see [SKCamera Object Type](/SKCamera.md))

- `trackObject (Object, 0)` → `SKConstraint.disatance(0...0, targetObject)`  
Enables you to specify an object the camera should track, ensuring that they remain in the center of the screen (a very easy way to achieve scrolling)

### <a id="shape" />Shape

Shape properties apply to rectangles, ellipses, polylines, and polygons

 - `fillColor (Color, RGBA(0,0,0,0))` → `SKShapeNode.fillColor`  
 The color used to fill the shape, defaults to clear

- `strokeColor (Color, RGBA(255,255,255,255))` → `SKShapeNode.strokeColor`  
The color used to stroke the shape, defaults to white

### <a id="physical" />Physical Object

Applies to tiles, rectangles, ellipses, polylines, polygons, and image objects (not layers). 

- `physicsCategory (Integer, 0)` → `SKNode.physicsBody.categoryBitMask`  
A 32bit bit mask used to set the category of the physics object. _No other physical object properties will be interpretted if this property is not set_

- `physicsCollisionMask (Integer, 0)` → `SKNode.physicsBody.collisionBitMask`  
Sets the SpriteKit collision mask for interactions between objects

 - `physicsContactMask (Integer, 0)` → `SKNode.physicsBody.contactBitMask`  
Sets the SpriteKit contact mask for the physics object

 - `physicsPreciseCollisions (Bool, false)` → `SKNode.physicsBody.usesPreciseCollisionDetection`  
Sets precise collision mode in SpriteKit (for small fast moving objects)

 - `affectedByGravity (Bool, true)` → `SKNode.physicsBody.affectedByGravity`  
If true the object will be affected by gravity

 - `isDynamic (Bool, true)` → `SKNode.physicsBody.isDynamic`  
If true the object will be included in the dynamic simulation of physics

 - `allowsRotation (Bool, true)` → `SKNode.physicsBody.allowsRotation`    
 Is the object allowed to rotate when the inverse kinematics are calculated

 - `mass (Float, -1)` → `SKNode.physicsBody.mass`  
The mass of the object, if not specified the mass will be automatically calculated by SpriteKit

 - `friction (Float, 0.2)` → `SKNode.physicsBody.friction`  
The co-efficient of friction of the surface of the object

 - `restitution (Float, 0.2)` → `SKNode.physicsBody.restitution`  
How bouncy the object is

 - `linearDamping (Float, 0.1)` → `SKNode.physicsBody.linearDamping`  
 How much velocity is lost when the object moves in space

- `angularDamping (Float, 0.1)` → `SKNode.physicsBody.angularDamping`  
How much velocity is lost when the object rotates in space


### <a id="edgeloop" />EdgeLoop Objects

Edge loops are polylines or polygons that are not part of the dynamic physic simulation (typically form the edges of the scene). They support a sub-set of Physics Properties that are enumerated here for convience and full descriptions can be found above

 - `physicsCategory`
 - `physicsCollisionMask`
 - `physicsContactMask`
 - `friction`
 - `restitution`

### <a id="light" />Light Object

Lights are captured as Tiled points only, and support the following properties

- `lightCategory (Integer, 0)` → `SKLightNode.categoryBitMask`  
A 32bit bit mask used to set the category of the light object. 

- `ambientColor (Color, RGB(255, 255, 255))` → `SKLightNode.ambientColor`  
The ambient color of the light

- `lightColor (Color, RGB(255, 255, 255))` → `SKLightNode.lightColor`  
The color of the light emitted by the `SKLightNode`

- `shadowColor (Color, RGB(0, 0, 0))` → `SKLightNode.shadowColor`  
The color of the shadow cast by the light

- `falloff (Float, 1.0)` → `SKLightNode.falloff`  
The rate of decay of the light

### <a id="lit" />Lit Sprite Objects

SpriteKit only lights sprites, although as SKTiledKit using sprites to represent the tiles in tile sets it is very easy to 
fully light your scene without further work needing to be done. 

- `litByMask (Integer, 0)` → `SKSpriteNode.lightingBitMask`  
The `lightCategory`'s that light this sprite

- `shadowedByMask (Integer, 0)` → `SKSpriteNode.shadowedBitMask`  
The `lightCategory`'s that cast shadows on this sprite

- `castsShadowsByMask (Integer, 0)` → `SKSpriteNode.shadowCastBitMask`  
The `lightCategory`'s that this sprite casts shadows from

- `normalImage (File)` → `SKSpriteNode.normalMap`  
An optional normal texture to use for the sprite
