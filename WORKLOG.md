# Work Log

## Alan Chen

### 5/22/2024

- Write Map class, which stores the positions of path waypoints
- Can render the path defined by the Map
- Write MapSegment class for Map
- Can check whether points are within the bounds of the path

### 5/23/2024

- Add more utility methods to Map and MapSegment
- Write BloonModifiersList and BloonModifier superclass (no implemented subclasses yet)
- Write Bloon constructors and move method
- Write BloonPropertiesLookup and BloonPropertiesTable, which read from bloons.json and get the corresponding properties for a given layer name

## 5/24/2024

- Bloons able to spawn children on death
- Basic damage method

## 5/25/2024

- Children spawn with offsets behind the parent position
- Damage method deals damage to children as well
- Add slightly more functionality for BloonModifiers
- Write WaveManager, which reads data to spawn Bloons from waves.json

## 5/26/2024

- Work on Camo and Regrow modifiers

## 5/27/2024

- Finish Camo and Regrow modifiers
- Add more waves to waves.json

## 5/28/2024

- Add MOAB-class Bloons and sprite rotations

## 5/29/2024

- Write a simple GUI library
- Write HealthManager and implement leaked Bloons dealing damage and losing when your health dips below 0
- Write CurrencyManager and implement damaging Bloons rewarding money
- Add GUI for health, currency, and wave count

## 5/30/2024
- Begin writing towers.json to refactor tower code

## 5/31/2024
- Write TowerPropertyLookup and related classes for parsing towers.json and applying properties
- Write ProjectileData to store projectile properties
- Write TowerAction to represent a tower attack
- Cleanup some code in Projectile and Tower in general
- Add pierce to projectiles

## 6/1/2024
- Write TowerUpgradeManager, which implements upgrade paths and reads upgrade information from towers.json and applies it accordingly to towers
- Add Dart Monkey Triple Darts
- Fix various issues with projectile rotation and pierce

## 6/2/2024
- Add Bomb Shooter Cluster Bombs
- Add a ton of images for the tower sprites and upgrade icons
- Fix small bugs with camo detection and add cash per wave

## 6/3/2024
- Cleanup GUI code with UpgradePanel and related classes

## 6/4/2024
- Cleanup GUI code with TowerSelectionPanel and related classes

## 6/5/2024
- Write basic cheat menu, with buttons for spawning the different bloon variants and toggling modifiers and infinite cash / health buttons

## 6/6/2024
- Write stun modifier and add Bloon Impact upgrade for Bomb Shooter
- Fix Cluster Bomb bugs
- Improve explosion hits using new intersection methods

## 6/7/2024
- Add Super Monkey tower and its upgrades
- Cleanup some of the tower upgrade parsing code

## 6/8/2024
- Add Ninja Monkey tower and its upgrades
- Add skip wave, start wave, remove bloons buttons to cheat menu
- Improve tower placement and selection

## 6/9/2024
- Fix various bugs with tower upgrades
- Add tower upgrade descriptions for UI
- Add missing images for upgrade icons and tower sprites

## Alex Luo

### 5/22/2024

- Wrote the basis of Game class (prim functions of the game)
- Wrote the basis of Main class (main class for the game to run in processing)

### 5/23/2024

- Began Tower Class (prim functions and constructor)
- Created it's respective subclasses (BombShooter, IceMonkey, SuperMonkey, DartMonkey)
- attack method for towers

### 5/24/2024
- wrote attack method for tower subclasses
- started working on upgrade paths
- wrote Slow

### 5/25/2024
 - began writing code to placeTowers
 - added more tower functionality (such as getCost())

### 5/26/2024
 - wrote towerTargetFilter class
 - created Projectile class and it's respective methods

### 5/27/2024
 - improved update from Projectile to destroy bloons
 - added tower sprites

### 5/28/2024
 - implemented rotating towers and rotating projectiles
 - added sprites for darts

 ### 5/29/2024
 - added the upgradeTower button functions(the base which later became part of the GUI)
 - added UI for the tower label

 ### 5/30/2024
- added sell button
- added bomb projectiles (clusterbombs and bombs)
- wrote bomb class (stats were later put in a JSON in accordance to the new tower class)
- wrote bombShooter attack 

### 5/31/2024
- added imageButton class 
- added towerButton(an imageButton) (to place towers)

### 6/2/2024
 - added bombshooter upgrades in the JSON
 - added tower highlighting 
 - added horizontal tower interface 
 - added imageButtons for dartmonkey

### 6/3/2024
 - upgraded costs (so they are BTD5 like)
 - fixed currency for selling towers
 - added an alpha updating horizontal GUI for upgrades

### 6/5/2024
 - added map
 - fixed currency so that it accounts for placing towers(and not having enough)

### 6/7/2024
 - added upgrade costs (in terms of functionality with currency)
 - fix map segments to account for new map

### 6/8/2024
 - added a start screen and play button
 - added an end screen and pause button 
 - added a speed up/pause button

### 6/9/2024
 - added snipermonkey class
 - added it's respective upgrades and PNGS
 - created the video presentation


 