class_name Player
extends CharacterBody3D

#var SPEED = 5
const JUMP_VELOCITY := 4.5
var mouse_sensitivity := 0.25
var walk_speed = 2
var sprint_speed = 5
const vertical_look_limit := 89
@export var BOB_FREQ = 5
@export var BOB_AMP = 0.04
var t_bob = 0.0

var can_step: bool = false
var moving: bool
var current_speed = 5.0
var lerp_speed = 10.0
var direction = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const default_fov := 75.0
var zoom_increment := 5.0
const max_zoom := 30.0
const zoom_limit := 2
var zoomed: bool = false

@export var in_dialogue: bool = false

@onready var HEAD: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D


# subscenes / managers
@onready var footstep_manager: Node3D = $FootstepManager
@onready var interaction_manager: Node3D = $InteractionManager
@onready var player_data: PlayerData = $PlayerData



signal step


func _ready() -> void:
	moving = false
	player_data.player = GameState.player
	player_data._setup()
	#print(player_data.dialogue_history)
	camera_3d.fov = default_fov
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x  * mouse_sensitivity))
		HEAD.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		HEAD.rotation.x = clamp(HEAD.rotation.x, deg_to_rad(-vertical_look_limit), deg_to_rad(vertical_look_limit))
	
	
	# camera zoom functionality
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		# zoom out => larger FOV value
		if camera_3d.fov >= max_zoom:
			camera_3d.fov = clamp(camera_3d.fov + zoom_increment, max_zoom, default_fov)
			
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		# zoom in => smaller FOV value
		if camera_3d.fov <= default_fov:
			camera_3d.fov = clamp(camera_3d.fov - zoom_increment, max_zoom, default_fov)
	

func _physics_process(delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if camera_3d.fov != default_fov:
		zoomed = true
	else:
		zoomed = false
	
	
	if not is_on_floor():
		velocity.y  -= gravity * delta
		
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	else:
		current_speed = walk_speed
	
	var input_dir = Input.get_vector("strafe left", "strafe right", "move forward", "move backward")
	var dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if dir != Vector3.ZERO:
		moving = true
		var move_vec = dir * current_speed
		velocity.x = move_vec.x
		velocity.z = move_vec.z
	else:
		velocity.x = 0
		velocity.z = 0
		moving = false
	
	t_bob += delta * velocity.length() * float(moving)
	handle_footsteps(t_bob)
	
	move_and_slide()


func handle_footsteps(time) -> void:
	var pos = Vector3.ZERO
	var low_pos = BOB_AMP - 0.05
	pos.y = sin(t_bob * BOB_FREQ) * BOB_AMP
	
	if pos.y > -low_pos:
		can_step = true
	
	if pos.y < -low_pos and can_step:
		can_step = false
		emit_signal("step")
