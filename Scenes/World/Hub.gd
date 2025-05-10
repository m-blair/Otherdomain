extends Room

@onready var player_count_label: Label3D = $Decorative/PlayerCountLabel
@onready var otherdomain_sign: ColorfulLabel3D = $Decorative/OTHERDOMAINSign

func _ready() -> void:
	otherdomain_sign.color_shifting = true
	await get_tree().create_timer(3).timeout
	player_count_label.text = "PLAYERS ONLINE:            1"
