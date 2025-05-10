extends HUDElement

@onready var shade: ColorRect = $Shade

@onready var hud: HUD = $".."




signal fade_out(color: Color)
signal fade_in(color: Color)
signal effect_finished
signal effect_paused

func _on_fade_out(to_color: Color) -> void:
	show()
	shade.show()
	var tween = get_tree().create_tween()
	tween.tween_property(shade, "color", to_color, 3)
	await tween.finished
	effect_finished.emit()
	print("effect finished...")
	tween.kill()
	shade.hide()
	shade.color = Color("#00000000")
	
	hide()
	


func _on_fade_in(from_color: Color) -> void:
	show()
	shade.show()
	var tween = get_tree().create_tween()
	shade.color = from_color
	tween.tween_property(shade, "color", Color.TRANSPARENT, 3)
	effect_finished.emit()
	tween.kill()
	shade.hide()
	shade.color = from_color
	hide()
