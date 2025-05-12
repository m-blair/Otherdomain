extends Node3D

@export var footstep_sfx: Array[AudioStreamWAV]
@export var ground_level: Marker3D
@onready var player: Player = get_parent()


func _ready() -> void:
	player.step.connect(play_footstep)
	


func play_footstep() -> void:
	var audio_player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	#var rand_idx: int = randi_range(0, footstep_sfx.size() - 1)
	var rand_idx = 0
	audio_player.stream = footstep_sfx[rand_idx]
	audio_player.bus = &"SFX"
	audio_player.volume_db = -20
	
	audio_player.pitch_scale = randf_range(0.8, 1.2)
	ground_level.add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(func destroy(): audio_player.queue_free())
	
