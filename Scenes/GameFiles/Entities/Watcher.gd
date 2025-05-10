@icon("res://Assets/Icons/Arrows To Eye.svg")
class_name Watcher extends Entity

@onready var eyes: Sprite3D = $Eyes

var player_in_range: bool = false

var player_target: Player

var player_looking: bool = false
var look_duration: float = 0.0

@onready var stopwatch: Stopwatch = $Stopwatch
@onready var blink_timer: Timer = $BlinkTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


signal staring_contest_request


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	# blink randomly while player is out of range
	if not player_in_range:
		if eyes and animation_player:
			if blink_timer.is_stopped():
				var wait_time = randf_range(0.5, 45)
				blink_timer.wait_time = wait_time
				blink_timer.start()
	
	# pseudo-billboard sprite
	#if player_target:
		#track_player()
	#else:
		#look_for_player()


func track_player() -> void:
	look_at(player_target.global_position, Vector3.UP)


func follow_player() -> void:
	look_at(player_target.global_position, Vector3.UP)
	


func look_for_player() -> void:
	var target = get_tree().get_first_node_in_group("Player")
	if target:
		player_target = target
		eyes.look_at(player_target.global_position, Vector3.UP, true)
		


func _on_blink() -> void:
	animation_player.play("blink")
	await animation_player.animation_finished





func _on_player_entered(body: Node3D) -> void:
	if body is Player:
		player_in_range = true
		player_target = body
		staring_contest_request.emit()


func _on_player_exited(body: Node3D) -> void:
	player_in_range = false
