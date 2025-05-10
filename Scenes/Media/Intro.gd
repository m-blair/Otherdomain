extends Control

@onready var story_text_balloon: StoryTextBalloon = $StoryTextBalloon

var STORY = preload("res://Scripts/Dialogue/Story.dialogue")
@onready var text: RichTextLabel = $BG/Label
@onready var skip_button: Button = $SkipButton
@onready var curtain: ColorRect = $Curtain
@onready var click: AudioStreamPlayer = $click
@onready var bg_music: AudioStreamPlayer = $"bg-music"


const scroll_duration: float = 90.0
signal done

func _ready() -> void:
	text.position = Vector2(448, 1081)
	var tween = get_tree().create_tween()
	var skip_tween = get_tree().create_tween()
	skip_tween.tween_property(skip_button, "self_modulate", Color("#ffffff"), 12)
	tween.tween_property(text, "position", Vector2(448, -2526), scroll_duration)
	await tween.finished
	await get_tree().create_timer(5).timeout
	var shade = get_tree().create_tween()
	shade.tween_property(curtain, 'self_modulate', Color.WHITE, 3)
	await shade.finished
	hide()
	done.emit()
	queue_free()

func _process(delta: float) -> void:
	if skip_button:
		if skip_button.modulate == Color.TRANSPARENT:
			skip_button.disabled = true
		else:
			skip_button.disabled = false
	
	if curtain:
		if curtain.self_modulate == Color.TRANSPARENT:
			curtain.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			curtain.mouse_filter = Control.MOUSE_FILTER_STOP





func _on_skipped() -> void:
	click.play()
	var shade = get_tree().create_tween()
	shade.tween_property(curtain, 'self_modulate', Color.WHITE, 3)
	await shade.finished
	#var tweens = get_tree().get_processed_tweens()
	#if not tweens.is_empty():
		#for t in tweens:
			#t.kill()
	
	if bg_music.is_playing():
		bg_music.stop()
	hide()
	done.emit()
	queue_free()


func _on_skip_button_mouse_entered() -> void:
	skip_button.modulate = Color("#007f00")


func _on_skip_button_mouse_exited() -> void:
	skip_button.modulate = Color.LIME
