extends Control

# sliders
@onready var mouse_sens_slider: HSlider = $BasicOptions/GridContainer/MouseSensSlider
@onready var walk_speed_slider: HSlider = $BasicOptions/GridContainer/WalkSpeedSlider
@onready var sprint_speed_slider: HSlider = $BasicOptions/GridContainer/SprintSpeedSlider
@onready var fov_slider: HSlider = $BasicOptions/GridContainer/FOVSlider

# value labels
@onready var mouse_sensitivity: Label = $BasicOptions/GridContainer/MouseSensitivity
@onready var walk_speed: Label = $BasicOptions/GridContainer/WalkSpeed
@onready var sprint_speed: Label = $BasicOptions/GridContainer/SprintSpeed
@onready var fov: Label = $BasicOptions/GridContainer/FOV

@onready var grid_container: GridContainer = $BasicOptions/GridContainer


@onready var more_options: Button = $MoreOptions


@onready var booweep: AudioStreamPlayer = $"../../../Booweep"


var player: Player = null


func _ready() -> void:
	if GameState.player:
		player = GameState.player
	
	for node in grid_container.get_children():
		if node is HSlider:
			node.drag_ended.connect(_on_slider_drag_started.bind(node))
			node.value_changed.connect(format_slider_value.bind(node))



func format_slider_value(slider: HSlider) -> void:
		match slider:
			mouse_sens_slider:
				mouse_sensitivity.set_text("%.2f" % mouse_sens_slider.value)
				player.mouse_sensitivity = mouse_sens_slider.value
			walk_speed_slider:
				walk_speed.set_text("%f" % walk_speed_slider.value)
				player.walk_speed = walk_speed_slider.value
			sprint_speed_slider:
				sprint_speed.set_text("%f" % sprint_speed_slider.value)
				player.sprint_speed = sprint_speed_slider.value
			fov_slider:
				fov.set_text("%d°" % fov_slider.value)
				player.camera_3d.fov = fov_slider.value
		

func _on_slider_drag_started(slider: HSlider) -> void:
	pass
