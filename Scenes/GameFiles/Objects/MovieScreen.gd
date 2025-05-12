class_name MovieScreen extends InteractiveObject3D

enum Films {Film1, Film2, Film3, NONE}
@export var current_film: Films
@onready var picture: Sprite3D = $Picture

func _ready() -> void:
	pass


func get_frame_color() -> Color:
	var texture = picture.texture as AnimatedTexture
	var img = texture
	
	return Color.WHITE
