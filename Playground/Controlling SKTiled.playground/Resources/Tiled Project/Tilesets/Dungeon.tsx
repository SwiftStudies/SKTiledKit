<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.4" tiledversion="1.4.2" name="Dungeon" tilewidth="16" tileheight="16" tilecount="256" columns="16">
 <properties>
  <property name="filteringMode" value="nearest"/>
 </properties>
 <image source="../Images/DungeonTiles.png" width="256" height="256"/>
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
  <objectgroup draworder="index" id="2">
   <object id="1" x="4" y="0" width="8" height="14">
    <properties>
     <property name="collisionMask" type="int" value="1"/>
    </properties>
   </object>
  </objectgroup>
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
</tileset>
