extends Control



# main controls
@onready var main: Control = $Main
@onready var selections: HBoxContainer = $Main/Selections
@onready var start_button: Button = $Main/Selections/Start
@onready var load_button: Button = $Main/Selections/Load
@onready var options_button: Button = $Main/Selections/Options
@onready var quit_button: Button = $Main/Selections/Quit

@onready var return_button: Button = $Return



# load submenu
@onready var load_region: Control = $Load
@onready var slots: GridContainer = $Load/Slots
@onready var begin_button: Button = $Begin
@onready var slots_top_label: RichTextLabel = $Load/SlotsTopLabel


# options submenu
@onready var options: Control = $Options

const slots_start_pos := Vector2(1928, 216)
const slots_end_pos := Vector2(1216, 216)



@onready var bg_music: AudioStreamPlayer = $"bg-music"
@onready var blup: AudioStreamPlayer = $blup
@onready var booweep: AudioStreamPlayer = $booweep


@onready var camera_animator: AnimationPlayer = $SubViewportContainer/SubViewport/Node3D/CameraAnimator


@onready var curtain: ColorRect = $Curtain


signal done(dest_screen: StringName)


func _ready() -> void:
	for node in selections.get_children():
		if node is Button:
			var button = node as Button
			button.text = button.name.to_upper()
			button.mouse_entered.connect(_on_mouse_entered_option.bind(button))
			button.mouse_exited.connect(_on_mouse_exited_option.bind(button))
	
	return_button.mouse_entered.connect(_on_mouse_entered_option.bind(return_button))
	return_button.mouse_exited.connect(_on_mouse_exited_option.bind(return_button))
	
	begin_button.mouse_entered.connect(_on_mouse_entered_option.bind(begin_button))
	begin_button.mouse_exited.connect(_on_mouse_exited_option.bind(begin_button))
	
	for node in slots.get_children():
		if node is Button:
			var button: Button = node
			button.toggled.connect(_on_save_slot_selected.bind(button))

	
	show_submenu(0)
	
	camera_animator.play("rise2")
	await camera_animator.animation_finished
	camera_animator.play("idle")


func _process(delta: float) -> void:
	if curtain:
		if curtain.self_modulate == Color.TRANSPARENT:
			curtain.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			curtain.mouse_filter = Control.MOUSE_FILTER_STOP



func show_submenu(id: int) -> void:
	main.hide()
	load_region.hide()
	options.hide()
	return_button.show() if id in [1, 2] else return_button.hide()
	begin_button.hide()
	match id:
		0: main.show()
		1: load_region.show()
		2: options.show()
		_: pass
	

func deselect_others(node) -> void:
	for i in slots.get_children():
		if i is Button and i != node:
			var button: Button = i
			button.set_pressed_no_signal(false)
				


func fade_out():
	var shade = get_tree().create_tween()
	shade.tween_property(curtain, 'self_modulate', Color.WHITE, 3)
	await shade.finished
	shade.kill()



func _on_save_slot_selected(toggled_on: bool, button: Button) -> void:
	if toggled_on:
		deselect_others(button)
		booweep.play()
		var index = button.get_index()
		print(index)
		begin_button.show()
		# get save data here?
		
	else:
		blup.play()
		begin_button.hide()



func _on_mouse_entered_option(button: Button) -> void:
	blup.play()
	var rich_text_label = button.get_child(0) as RichTextLabel
	rich_text_label.text = "[pulse freq=2.0 amp=0.5][outline_size=5]%s[/outline_size][/pulse]" % button.name.to_upper()
	#button.add_theme_constant_override("outline_size", 0)



func _on_mouse_exited_option(button: Button) -> void:
	blup.play()
	var rich_text_label = button.get_child(0) as RichTextLabel
	rich_text_label.text = "%s" % button.name.to_upper()



func _on_start_pressed() -> void:
	booweep.play()
	var shade = get_tree().create_tween()
	shade.tween_property(curtain, 'self_modulate', Color.WHITE, 3)
	await shade.finished
	shade.kill()
	done.emit(&"Game")



func _on_load_pressed() -> void:
	slots_top_label.show()
	booweep.play()
	main.hide()
	show_submenu(1)
	slots.position = slots_start_pos
	var tween = get_tree().create_tween()
	tween.tween_property(slots, "position", slots_end_pos, 0.75)
	await tween.finished
	tween.kill()
	#var shade = get_tree().create_tween()
	#shade.tween_property(curtain, 'self_modulate', Color.WHITE, 3)
	#await shade.finished
	#done.emit(Global.SCREENS.LOAD)



func _on_options_pressed() -> void:
	booweep.play()
	show_submenu(2)
	



func _on_quit_pressed() -> void:
	booweep.play()
	var shade = get_tree().create_tween()
	shade.tween_property(curtain, 'self_modulate', Color.WHITE, 2)
	await shade.finished
	get_tree().quit()


func _on_return_pressed() -> void:
	blup.play()
	slots_top_label.hide()
	deselect_others(return_button)
	var tween = get_tree().create_tween()
	tween.tween_property(slots, "position", slots_start_pos, 0.75)
	await tween.finished
	tween.kill()
	show_submenu(0)
	
