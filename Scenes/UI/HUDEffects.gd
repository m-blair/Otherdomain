extends HUDElement

@onready var shade: ColorRect = $Shade
@onready var cash_text: RichTextLabel = $CashText

const CASH_TEXT_BOTTOM_POS := Vector2(800, 1096)
const CASH_TEXT_TOP_POS := Vector2(800, 528)

@onready var hud: HUD = $".."




signal fade_out(color: Color)
signal fade_in(color: Color)
signal flash_cash_text(amount: float)
signal effect_finished
signal effect_paused


func _on_fade_out(to_color: Color) -> void:
	cash_text.hide()
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
	cash_text.hide()
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



func _on_flash_cash_text(amount: float) -> void:
	show()
	cash_text.set_text("+ $%05.2f" % amount)
	cash_text.position = CASH_TEXT_BOTTOM_POS
	cash_text.modulate = Color.WHITE
	cash_text.show()
	var tween = get_tree().create_tween()
	tween.tween_property(cash_text, "modulate", Color.TRANSPARENT, 3)
	tween.parallel().tween_property(cash_text, "position", CASH_TEXT_TOP_POS, 3)
	await tween.finished
	tween.kill()
	cash_text.hide()
	hide()
