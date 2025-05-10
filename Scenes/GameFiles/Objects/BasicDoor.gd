class_name BasicDoor extends Door

@onready var open_sfx: AudioStreamPlayer = $open_sfx
@onready var close_sfx: AudioStreamPlayer = $close_sfx


func _ready() -> void:
	room_enter_spot_1 = $RoomEnterSpot1
	room_enter_spot_2 = $RoomEnterSpot2



# if the door mesh has a hinge
var ajar: bool = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		Signals.found_object.emit(self)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		Signals.left_object.emit(self)
