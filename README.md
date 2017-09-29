# Super Disease - The Game

## Actual Version
	0.2

## Game name
 	Super Disease.

## Story
	You're a microorganism. But not an ordinary one, you're Super D. A virus that came from
	another planet and has a giant and powerful weapon, your boxing glove! Living as a virus in a hostil environment, 
	like human body, it's not that easy. You must ensure your survival and make sure that your kind plorifere, 
	by defeating inside body's antibodies, known as N-Ts, and penetrating system's 
	main cell to install your own core in it.

## Goal
	Your goal it's to achieve what any microorganism has ever done, yet: dominate human 
	nervous system's main cell, and overcome human race as dominant species at planet Earth.

## Game navigation diagram
 
![alt text](https://github.com/ManoelSilva/super-d-the-game/blob/master/assets/img/game-diagram.png)

* Levels
```
	Each level represent a human system, divided in two or three sublevels. For this project,
	the game will try to reproduce respiratory, digestive and nervous systems.
```

## Specific objectives
	Kill the number necessary of Nts to move to the next level;
	Kill level's boss to reach main cell;
	Kill main cell to introduce your own core and dominate body system, obtaining a new power.

## Life system
	Super D's life is represented by 3 blue circles, splited in four quadrants, who will by placed on the top left 
	corner of the screen, totalizing 12 points of life.

## Points system
	Super Disease game's points system it's quite very simple. In each sublevel, of each level, it will be given a 
	number of Nts that you must kill. Each Nt dead will increase one point.
	
* Points of each level
```
	First level-> Random number of 40-60, increasing initial interval by 5 in each sublevel.
	Second level-> Random number of 60-80, increasing initial interval by 5 in each sublevel.
	Third level-> Random number of 80-100, increasing initial interval by 5 in each sublevel.
```

## End of the game
	The game end when Super D reaches nervous system and dominate his main cell. Controlling human body and 
	subsequently human race.

## Special considerations and credits
	Game developed using Corona®.
	Game and sprites arts developed by Manoel Silva, me. :) Using Inkscape®,
	to vectorize my drawings, TexturePacker® and ShoeBox® to generate sprite sheets and sprite map.
	Super Disease arts were inspired in Sonic the Hedgehog, Alex Kid (Sega®) and 
	Super Mario (Nintendo®).
	Background image of demo version 0.0.4 was obtained in google images. Unknown creator, all credits given.
	Sound effects and music credits of demo version 0.0.4 are given to Sega®, Nintendo® and 
	Vintage Culture (Musics - You Can't Hide, Hollywood).
	Fonts:
		http://www.dafont.com/pt/star-jedi.font
		http://www6.flamingtext.com

## Versions Features
```
	These version features are like a development diary to me. I'm not using any 
	software versioning pattern like major.minor.whatever. Those numbers came out 
	of my building tests and mostly of my head, after all is my project, my game. 
	Hope you guys enjoy. :)
```
	
	**0.0.4**
		First demostration of game's project.
		Super D animations almost complete.
		Physics, gravity and collision first implementation.
		All sound effects, background music and sprites are subject to change.
	**0.0.4.2**
		Super D animations 90% complete.
		Fixed invincibility issue after punch (if player has stood still).
		Life system development start.
	**0.0.4.4**
		Life system development complete.
		Composer first implementation.
		Points system development start.
	**0.0.4.5**
		SuperD can't go off sides screen anymore.
		Some physics improvements.
		N-Ts generate time decrease.
		N-Ts moving faster.
	**0.0.4.6**
		Points system development complete.
		Fixed bug after being hit immediately after dying.
	**0.0.4.7**
		N-Ts attack first implementation.
	**0.0.6**
		Better graphics.
		Nucleum of life development start.	
	**0.0.7**
		Increase life system complete.
		Factory of Nucleums development start.
	**0.1**
		Factory of Nucleums development complete.
		Level template development complete.
	**0.2**
		Game tutorial development start.