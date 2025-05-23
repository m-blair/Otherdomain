extends Node3D


#var scenes: Dictionary = {0: "res://Scenes/Menus/TitleScreen.tscn", 1: "res://Scenes/GameFiles/Game.tscn", 5: "res://Scenes/UI/HUD.tscn",
#2: "res://Scenes/World/Roads.tscn", 3: "res://Scenes/World/Room1A.tscn", 10: "res://Scenes/Media/Introduction.tscn", 4: "res://Scenes/World/TestingZone.tscn",
#11: "res://Scenes/World/Room2A.tscn", 12: "res://Scenes/World/Room3A.tscn", 13: "res://Scenes/World/Room4B.tscn",
#-1: "res://Scenes/World/Hub.tscn"}
var TITLE_SCREEN = preload("res://Scenes/Menus/TitleScreen.tscn").instantiate()
var ITEM_DB = preload("res://Scenes/GameFiles/Items/ItemDB.tscn").instantiate()


var ROOMS = preload("res://Data/Rooms.tres")
var SCENE_GUIDE = preload("res://Data/SceneGuide.tres")


var room_to_scene_id := {&"Roads": 2, &"1A": 3, &"Testing": 4, &"2A": 11, &"3A": 12, &"4B": 13, &"Hub": -1}

var GAME: Game

func _ready() -> void:
	Global.ItemDB = ITEM_DB
	add_child(ITEM_DB)
	add_child(TITLE_SCREEN)
	TITLE_SCREEN.done.connect(_on_title_done)
	# loading shaders
	var VHS = preload("res://Shaders/VHS.tscn").instantiate()
	add_child(VHS) 
	VHS.layer = 10
	await TITLE_SCREEN.done



func get_scene_path(scene_id: StringName) -> String:
	if ROOMS.rooms.keys().has(scene_id):
		return ROOMS.rooms[scene_id]
	elif SCENE_GUIDE.rooms.keys().has(scene_id):
		return SCENE_GUIDE.rooms[scene_id]
	else:
		return "res://Scenes/Menus/TitleScreen.tscn"



func change_room(scene_path: String) -> void:
	assert(GAME != null)
	if GAME.current_room != null:
		var cur_room: Room = GAME.current_room
		GAME.remove_child(cur_room)
		var scene = load(scene_path) as PackedScene
		var next_room: Room = scene.instantiate()
		GAME.add_child(next_room)
		GAME.move_child(next_room, 0) # make sure new room scene is behind the HUD in the tree
		GAME.current_room = next_room


func change_scene(scene_id: StringName) -> void:
	var scene = load(get_scene_path(scene_id)).instantiate()
	if scene.name == "Game":
		GAME = scene
		GAME.room_change.connect(_on_room_exited_change_request)
		
	if scene != null:
		get_tree().current_scene = scene
		get_tree().change_scene_to_packed(scene)
		add_child(scene)
		
	print(scene.name)


func _on_title_done(destination_scene: StringName) -> void:
	var scene_path = get_scene_path(destination_scene)
	remove_child(TITLE_SCREEN)
	#var INTRODUCTION = load("res://Scenes/Media/Introduction.tscn").instantiate()
	#add_child(INTRODUCTION)
	#await INTRODUCTION.done
	change_scene(destination_scene)




func _on_room_exited_change_request(scene_id: StringName, next_door_id: int) -> void:
	var path = get_scene_path(scene_id)
	change_room(path)
	Signals.entered_room.emit(next_door_id)
