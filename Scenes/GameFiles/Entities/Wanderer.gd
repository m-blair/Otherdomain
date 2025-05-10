@icon("res://Assets/Icons/Person Walking.svg")
class_name Wanderer 
extends Entity

@onready var animation_player: AnimationPlayer = $Wanderer/AnimationPlayer
@onready var sound_animation_player: AnimationPlayer = $SoundAnimationPlayer
@onready var action_animation_player: AnimationPlayer = $ActionAnimationPlayer

@onready var exclamation_point: Sprite3D = $Wanderer/Armature/Skeleton3D/BoneAttachment3D/ExclamationPoint

@onready var tv_static: AudioStreamPlayer3D = $TVstatic

var target: CollisionObject3D
var dist_to_target


signal target_found(target_)


func _ready() -> void:
	exclamation_point.hide()


func _process(delta: float) -> void:
	if target:
		if not tv_static.is_playing():
			tv_static.play()
		follow_target(delta)
	else:
		search_for_player()
		tv_static.stop()


func search_for_player() -> void:
	if get_tree().get_first_node_in_group("Player") != null:
		var p: Player = get_tree().get_first_node_in_group("Player")
		var dist_to = position.distance_to(p.global_position)


func follow_target(delta: float) -> void:
	if target:
		move_toward(target.global_position.x, target.global_position.z, delta)

func _on_target_found(target_: Variant) -> void:
	if target_ is Player:
		target = target_
		action_animation_player.play("found")
		sound_animation_player.play("found target")
		await action_animation_player.animation_finished
		print("found u.")
