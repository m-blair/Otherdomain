@icon("res://Assets/Icons/Hands.svg")
class_name RPSGuy extends Entity

@export var full_name: String = "Hans"

@onready var rps_guy_animation_player: AnimationPlayer = $RPSGuyAnimationPlayer
@onready var pivot: Node3D = $Pivot

enum Sides {LEFT, RIGHT}
@export var side: Sides

var poses = {0: "rock", 1: "paper", 2: "scissors"}


@onready var top_hand: Hand = $TopHand
@onready var bottom_hand: Hand = $BottomHand

var opponent: Variant
@export var playing: bool = false
@export var in_range_of_opponent: bool = false

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D




func _ready() -> void:
	rps_guy_animation_player.play("idling")



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player and not near_player:
		near_player = true
		Signals.found_entity.emit(self)
		
	elif body is RPSGuy and not opponent:
		in_range_of_opponent = true
		

func _on_area_3d_body_exited(body: Node3D) -> void:
	
	if body is Player and near_player:
		near_player = false
		Signals.left_entity.emit(self)
	
	elif body is RPSGuy:
		in_range_of_opponent = false 
