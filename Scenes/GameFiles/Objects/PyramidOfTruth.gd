@icon("res://Assets/Icons/Database.svg")
class_name PyramidOfTruth
extends InteractiveObject3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var PYRAMID_OF_TRUTH = preload("res://Scripts/Dialogue/PyramidOfTruth.dialogue")



func _ready() -> void:
	animation_player.play("idle")





func _on_passive_detection_zone_body_entered(body: Node3D) -> void:
	if body is Player:
		#print("player nearby Pyramid of Truth!!")
		player_in_range = true
		Signals.found_object.emit(self)


func _on_passive_detection_zone_body_exited(body: Node3D) -> void:
	if body is Player:
		#print("player leaving range of Pyramid of Truth!!")
		player_in_range = false
		Signals.left_object.emit(self)
