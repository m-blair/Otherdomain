@tool
@icon("res://Assets/Icons/Gift.svg")
class_name ItemDrop extends InteractiveObject3D

@export var item: Item:
	set(new_item):
		if sprite:
			sprite.texture = new_item.icon
		item = new_item


@export var sprite_billboarding: bool:
	set(val):
		sprite_billboarding = val
		if sprite:
			if val:
				sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
			else:
				sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED


@onready var sprite: Sprite3D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer




signal item_drop_pickup_request(item)
signal picked_up

func _ready() -> void:
	if not sprite_billboarding:
		animation_player.play("spin")



func fill_item_data(item_: Item) -> void:
	sprite.texture = item_.icon
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		player_in_range = true
		Signals.found_object.emit(self)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		player_in_range = false
		Signals.left_object.emit(self)


#func 


func _on_picked_up() -> void:
	hide()
	queue_free()
