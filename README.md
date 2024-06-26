[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/syDSSnTt)
# APCS2 Final Project
THIS DOCUMENT IS REQUIRED
## Group Info

Group Name: Blooners  
Period 3, Alan Chen, Alex Luo

## Overview

A simple recreation of BTD5 that consists of towers, upgrades, a map, bloons that travel through the map, a wave system, and simple GUI. 
Place towers to defend the exit from waves of bloons. Dealing damage to bloons and clearing waves will reward you with money, which you can use to purchase upgrades (choosing between 2 upgrade paths) or more towers.  
When bloons reach the exit, they will damage your life total; when that reaches 0 or below, you LOSE.  
Bloons come in various shapes, sizes, and... colors, and different towers will interact with them differently. Some bloons are immune to explosive damage, others to sharp projectiles, and so on.  

## Presentation Link

https://drive.google.com/file/d/1my3wHzGBJ7nXcxiTdRiG00ZU_-HUFnSb/view?usp=sharing

## Instructions

**<u>Running the project</u>**: No extra steps or downloads needed. Just run it, and hopefully, everything will work.  

**<u>Basics</u>**: This game is a multistage anaerobic capacity test that progressively gets more difficult as it continues. The 35 wave survival will begin when you want it to. Maybe run the game in Processing first. The bloons start off weak and slow, but get stronger, faster, and more varied each wave. Completing a single wave will reward you with some extra money. Remember to spend your money, and spend as wisely as possible. The first time you fail to keep your health above 0, your game is over. The game will begin as soon as you press the play button. On your mark, get ready, press the play button.    
- Five towers (Dart Monkey, Sniper Monkey, Bomb Shooter, Ninja Monkey, Super Monkey), each with 2 upgrade paths and up to 4 upgrades on each path

**<u>Playing the game</u>**: At the bottom right corner, there are 2 buttons:
- **Pause**: Pauses game simulation, but you can still place towers
- **Double speed**: Simulates the game at 2x speed (i.e. all bloons and projectiles move 2x faster, all towers attack 2x faster, etc.)

**<u>Placing towers</u>**: Click on one of the tower buttons on the right sidebar, and then click somewhere on the map to place a tower. You cannot place if you're too poor, you cannot place on the track, and you cannot place too close to other towers.  

**<u>Upgrading towers</u>**: Click near the center of a placed tower to open the upgrade menu. There are 3 buttons (from left to right):
- **Sell**: Removes the tower and refunds the specified amount of cash
- **Upgrade path 1**: Upgrade the tower once on path 1, if you can afford it
- **Upgrade path 2**: Upgrade the tower once on path 2, if you can afford it  

You can purchase upgrades from both paths, but when you buy 3 or more upgrades from one path, you are restricted to only buying up to 2 upgrades from the other.  
Hovering over an upgrade button will enable a tooltip with a short description of what the next upgrade does. If you want to know exactly what an upgrade does (i.e. you think our tooltips are inadequate, which is very rude and disrespectful), look it up in data/towers.json.   

**<u>Cheats</u>**: If you wish to cheat, press the "C" key to open the cheat menu. You will find on the left side of the screen (from top to bottom):
- **Toggle camo**: Toggles camo for spawned bloons from the panel (most towers cannot detect camo without certain upgrades)
- **Toggle regrow**: Toggles regrow for spawned bloons from the panel (regenerate layers over time)
- **Grid of bloon spawn buttons**: Spawns the specified bloon, with camo and/or regrow modifiers if you enabled them with their respective toggles
- **HEALTH !!!**: Gives infinite lives
- **MONEY !!!**: Gives infinite cash
- **Remove bloons**: Removes all bloons currently on the map
- **Skip wave**: Stops all current wave spawns and immediately starts the next wave
- **Start next wave**: Immediately starts the next wave, but does NOT stop current wave spawns; this means bloons will keep spawning from the previous wave  

## Some Issues (but not really major bugs, just small things that you might notice and scratch your head over) and Other Notes
- Enabling 2x speed does not halve the wave spawn timers, so while everything else is correctly simulated at 2x speed, bloons will keep spawning at normal rates.
- The Distraction upgrade of the Ninja Monkey <i>might</i> (chances are that it won't, but we wouldn't bet on it) cause the game to crash. If it does crash, blame it on divine intervention because the code responsible for that upgrade was unholy, and at this point, what it does is completely out of our control.
- At higher waves, the high volumes of bloons and their children will create pretty bad lag. Lag will slow down everything, as simulation is tied to the frame rate.
- Some towers do not have fourth upgrades on certain paths because those upgrades would either be too big of an endeavour to implement (e.g. Super Monkey's Temple of the Sun God) or involves abilities, which we never planned on creating (e.g. most of the 4th upgrades on path 2).
- There is no way to pause a wave from spawning, unfortunately.
- There is a lose screen, but there is no win screen. When you win, the game will freeze, and you have to restart to replay.

