@icon("res://Assets/Icons/Database.svg")
class_name PyramidOfTruth
extends InteractiveObject3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var PYRAMID_OF_TRUTH = preload("res://Scripts/Dialogue/PyramidOfTruth.dialogue")



func _ready() -> void:
	if animation_player:
		animation_player.play("idle")





func _on_passive_detection_zone_body_entered(body: Node3D) -> void:
	if body is Player:
		player_in_range = true
		Signals.found_object.emit(self)
		animation_player.play("interact")
		await animation_player.animation_finished
		animation_player.play_backwards("interact")


func _on_passive_detection_zone_body_exited(body: Node3D) -> void:
	if body is Player:
		player_in_range = false
		Signals.left_object.emit(self)
		animation_player.play("idle")
