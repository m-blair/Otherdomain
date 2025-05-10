class_name NameTextBox extends HUDElement

var current_thing: Variant
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var label: Label = $Panel/Label


signal show_text_box(thing_: Variant)
signal hide_text_box


func show_name(thing_: Variant) -> void:
	current_thing = thing_
	
	if current_thing is ItemDrop:
		show_item_drop(current_thing)
	elif current_thing is Entity:
		show_entity(current_thing)


func get_real_entity_name(entity: Entity) -> String:
	return "Hans" if entity is RPSGuy else entity.name
		


func show_item_drop(item_drop: ItemDrop) -> void:
	label.set_text(item_drop.item.name.to_upper())
	show()
	animation_player.play("show")

func show_entity(entity: Entity) -> void:
	label.set_text(get_real_entity_name(entity).to_upper())
	show()
	animation_player.play("show")



func hide_name() -> void:
	hide()
	animation_player.play_backwards("show")
	current_thing = null
	
