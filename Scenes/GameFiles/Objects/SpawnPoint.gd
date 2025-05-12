class_name SpawnPoint
extends Area3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label_3d: Label3D = $Label3D

@export var player_inside: bool = false

func _ready() -> void:
	#body_entered.connect()
	animation_player.play("spin text")




func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		player_inside = true
		#print("PLAYER ENTERED!!")


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		player_inside = false
