class_name WoodenDoor extends Door


func _ready() -> void:
	room_enter_spot_1 = $RoomEnterSpot1
	room_enter_spot_2 = $RoomEnterSpot2


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		player_in_range = true
		Signals.found_object.emit(self)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		player_in_range = false
		Signals.left_object.emit(self)
