@icon("res://Assets/Icons/Door Open.svg")
class_name Door
extends InteractiveObject3D


@export var next_room_id: StringName
@export var next_door_id: int

@export var locked: bool
@export var open: bool =  not locked

@export var locked_hint: String
var lock_hint_seen: bool = false
@export var key_id: String
@export var door_id: int

## What side of the door the player spawns at in the next room
@export_range(0, 1) var player_spawn_location: int


@onready var room_enter_spot_1: Marker3D
@onready var room_enter_spot_2: Marker3D


signal unlocked


func _ready() -> void:
	pass





func try_unlock(item: Item) -> bool:
	assert(key_id != "")
	return true if item is Key and item.key_id == self.key_id else false


func get_collision_area(node: Node):
	if node is Area3D: return node
	for child in node.get_children():
		if child.get_child_count() > 0:
			var result = get_collision_area(child)
			if result:
				return result
	return null


func _on_body_entered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
