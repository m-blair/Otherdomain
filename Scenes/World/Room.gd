class_name Room
extends Node3D

@export var room_id: StringName
@onready var player: Player = $Player
@onready var spawn_point: SpawnPoint = $SpawnPoint

## The main vibe, theme, or general purpose of this room
@export_multiline var room_description: String

# whats in the room
@export var doors: Array[Door]
@export var drops: Array[ItemDrop]
@export var entities: Array[Entity]
@export var objects: Array[InteractiveObject3D]

func _ready() -> void:
	GameState.player = player
	GameState.current_room_id = room_id
	player.player_data.current_room = room_id
	setup()


func setup() -> void:
	for node in get_children():
		if node is InteractiveObject3D:
			if node is Door:
				doors.append(node)
				#print(node.name)
			elif node is ItemDrop:
				drops.append(node)
				#print(node.item.name)
			else:
				objects.append(node)
		elif node is Entity:
			entities.append(node)
			#print(node.name)
		


func get_door(door_id: int):
	for d in doors:
		if d.door_id == door_id:
			return d
	push_error("Room has no door with id = '%s'" % str(door_id))
	return null


func set_entry_pos(door_id: int):
	var door_entered = get_door(door_id)
	if door_entered:
		var door: Door = door_entered
		player.position = door.room_enter_spot_1.position if door.player_spawn_location == 0 else door.room_enter_spot_2.position


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DEBUG player reset") and player.position != spawn_point.position:
		player.position = spawn_point.position
