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
