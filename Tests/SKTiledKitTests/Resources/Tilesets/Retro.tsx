<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.4" tiledversion="1.4.2" name="Retro" tilewidth="16" tileheight="16" tilecount="256" columns="16">
 <properties>
  <property name="Credits" value="Many thanks to Robert for creating the free to use tile set included here. You can find it here: https://0x72.itch.io/16x16-dungeon-tileset"/>
  <property name="filteringMode" value="nearest"/>
 </properties>
 <image source="../Images/DungeonTiles.png" width="256" height="256"/>
 <tile id="50" type="SKSprite">
  <properties>
   <property name="litByMask" type="int" value="1"/>
   <property name="shadowedByMask" type="int" value="1"/>
  </properties>
 </tile>
 <tile id="63" type="SKSprite">
  <properties>
   <property name="affectedByGravity" type="bool" value="false"/>
   <property name="isDynamic" type="bool" value="true"/>
   <property name="physicsCategory" type="int" value="1"/>
   <property name="physicsCollisionMask" type="int" value="1"/>
   <property name="physicsContactMask" type="int" value="1"/>
  </properties>
  <objectgroup draworder="index" id="2">
   <object id="1" x="3.68309" y="3.61158" width="11.2922" height="11.6498">
    <ellipse/>
   </object>
   <object id="2" x="1.4821" y="5" width="5" height="3" rotation="313"/>
  </objectgroup>
 </tile>
 <tile id="116" type="SKSprite">
  <properties>
   <property name="litByMask" type="int" value="1"/>
  </properties>
 </tile>
 <tile id="152">
  <animation>
   <frame tileid="152" duration="100"/>
   <frame tileid="153" duration="100"/>
   <frame tileid="154" duration="100"/>
   <frame tileid="155" duration="100"/>
   <frame tileid="156" duration="100"/>
   <frame tileid="157" duration="100"/>
   <frame tileid="158" duration="100"/>
   <frame tileid="159" duration="100"/>
  </animation>
 </tile>
 <tile id="168">
  <animation>
   <frame tileid="168" duration="100"/>
   <frame tileid="169" duration="100"/>
   <frame tileid="170" duration="100"/>
   <frame tileid="171" duration="100"/>
   <frame tileid="172" duration="100"/>
   <frame tileid="173" duration="100"/>
   <frame tileid="174" duration="100"/>
   <frame tileid="175" duration="100"/>
  </animation>
 </tile>
 <tile id="252">
  <objectgroup draworder="index" id="2">
   <object id="1" name="Collision Box" type="SKShape" x="3.27273" y="1.18182" width="9.63636" height="13.6364"/>
  </objectgroup>
 </tile>
</tileset>
