extends HUDElement


@onready var action_text: RichTextLabel = $ActionText
@onready var action_animator: AnimationPlayer = $AnimationPlayer


## Signal to HUD to display the ControlPopup on screen when in front of an Entity or object
## param 'flags': overrides the first two args and just does that instead (names of dialogue lines)
signal show_control_popup(key_bind: String, text: String, flags: Array)
signal hide_control_popup



#func handle_flags() -> void:
	#if ""

func _on_show_popup(key: String, text: String, flags = []) -> void:
	#if not flags.is_empty():
		#handle_flags()
	if not flags.is_empty():
		action_text.set_text("[wave][b]%s[/b][/wave]" % flags[0])
		action_animator.play("show")
	else:
		#print("%s - %s" % [key, text])
		action_text.set_text("[wave][b]%s[/b]   %s[/wave]" % [key.to_upper(), text.to_upper()])
		action_animator.play("show")

func _on_hide_popup() -> void:
	action_text.text = ""
	action_animator.play_backwards("show")
	await action_animator.animation_finished
	open = false
