extends Room


@onready var item_drop: ItemDrop = $ItemDrop
@onready var rps_guy: RPSGuy = $RPSGuy
@onready var pyramid_of_truth: PyramidOfTruth = $PyramidOfTruth
@onready var obelisk_of_lies: ObeliskOfLies = $ObeliskOfLies


func _ready() -> void:
	GameState.player = player
	GameState.current_room_id = room_id
	rps_guy.rps_guy_animation_player.play("idling")
	rps_guy.position = Vector3(0, 0.153, -2.392)
	rps_guy.scale *= 0.5
