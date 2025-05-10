extends Node3D


@onready var raycast: RayCast3D = $"../Head/Raycast"
var current_collider

signal interacted(collider)

@onready var player: Player = $".."


func _input(event: InputEvent) -> void:
	if current_collider and Input.is_action_just_pressed("interact") and not player.in_dialogue:
		interacted.emit(current_collider)



func _process(delta: float) -> void:
	if raycast and raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is CollisionObject3D and collider != null:
			current_collider = raycast.get_collider()
	else:
		current_collider = null
		
