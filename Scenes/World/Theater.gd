extends Room


@onready var lights: Node3D = $Theater/Lights
@onready var theater: Node3D = $Theater/theater/Theater
@onready var movie_screen: Node3D = $MovieScreen

@onready var theater_player: AnimationPlayer = $Theater/AnimationPlayer


@export var playing_film: bool: set = set_playing_film
@onready var picture: Sprite3D = $MovieScreen/Picture


func set_playing_film(new_state: bool) -> void:
	if theater and lights and theater_player:
		if new_state:
			theater_player.play_backwards("lights toggle")
			await theater_player.animation_finished
			movie_screen.hide()
		else:
			theater_player.play("lights toggle")
			await theater_player.animation_finished
			await get_tree().create_timer(1).timeout
			movie_screen.show()
			
		playing_film = new_state


#func _process(delta: float) -> void:
	#if picture:
		#if picture.visible:
			#picture.


func _ready() -> void:
	super._ready()
	player.position = spawn_point.position
	player.safe_margin = 0.25
	playing_film = false
