class_name ColorfulLabel3D extends Label3D

@onready var timer: Timer = $Timer
const DEFAULT_COLOR := Color("#009784")
const WAIT_TIME := 5
@export var color_resource: Gradient
@export var color_shifting: bool = false
@export_range(0.1, 2.5) var shift_speed_scale: float = 0.5
@export var current_color: Color
var current_color_index := 0

func _ready() -> void:
	modulate = DEFAULT_COLOR
	

func _process(delta: float) -> void:
	if color_shifting:
		if timer.is_stopped():
			current_color = modulate


func get_next_color(idx: int) -> Color:
	if color_resource:
		return color_resource.colors[(idx + 1) % color_resource.colors.size()]
	return DEFAULT_COLOR


func _on_timer_timeout() -> void:
	if color_shifting:
		var tween = get_tree().create_tween()
		var duration = WAIT_TIME * shift_speed_scale
		timer.start(duration)
		var next = get_next_color(current_color_index)
		#print(next)
		tween.tween_property(self, "modulate", next, duration)
		await tween.finished
		current_color_index = (current_color_index + 1) % color_resource.colors.size()
		current_color = next
		tween.kill()
