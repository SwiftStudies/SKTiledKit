#  SKUserInterface

You can apply this type to any object (note that its properties can be applied map object in tiled including layers) if you wish to support user interfactions.  

When events are received (at this point this means tapping or clicking with a finger or mouse, but will be extended to support key and controller events also) specified named actions are run on the target object in the SpriteKit scene. You may register your own actions with `SpriteKitEngine` if you wish. 

The target object defaults to the object that is type to SKUserInterface (its self), however you can identify any other object to be the subject (such as the player). 

## Details

### Applies To Tiled Objects
 - Layers
 - Rectangle
 - Ellipse
 - Text
 - Image
 - Polyline
 - Polygon
 
### Supported Property Categories
 - [Interactable](Properties.md#interactable)
