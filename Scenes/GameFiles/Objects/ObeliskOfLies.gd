@icon("res://Assets/Icons/Database.svg")
class_name ObeliskOfLies
extends InteractiveObject3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("idle")


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		player_in_range = true
		Signals.found_object.emit(self)


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		player_in_range = false
		Signals.left_object.emit(self)
