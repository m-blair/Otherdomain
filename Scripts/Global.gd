extends Node

@onready var game: Game


const MAX_INVENTORY_SIZE := 32
var limit_capcity: bool = false

var ItemDB = null

enum SCREENS {
	TITLE = 0,
	NEW_GAME = -1,
	LOAD = -2,
	OPTIONS = -3,
	CREDITS = -4,
	GAME = 1,
	INTRO = 10
}

# enum ItemType {FILE, MAP, KEY, PARTIAL, MED, OTHER}
const ITEM_TYPE_COLORS : Dictionary = {0: Color.AQUA, 
1: Color.CORAL,
2: Color.YELLOW,
3: Color.SLATE_BLUE ,
4: Color.GREEN,
5: Color.WHITE}


var entities = ["Watcher", "Hans", "Wanderer", "Mujimbi", "Odysseus"]

var chars_to_ignore = ["???", "Player"]

var characters: Dictionary[String, Color] = {"???": Color.DODGER_BLUE, 
"Player": Color.WEB_GRAY, 
"Watcher": Color.CRIMSON, 
"Pyramid Of Truth": Color.DARK_SEA_GREEN,
"Obelisk Of Lies": Color.DEEP_PINK,
"Hans": Color.GOLDENROD
}
