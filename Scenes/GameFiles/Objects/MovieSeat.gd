@tool
@icon("res://Assets/Icons/Chair.svg")
extends InteractiveObject3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var drink: Node3D = $Drink
@onready var mesh: Node3D = $Mesh



@export var closed: bool:
	set(val):
		if animation_player:
			if closed and val:
				# true -> true
				pass
			elif closed and not val:
				# true -> false
				animation_player.play_backwards("close")
			elif not closed and val:
				# false -> true
				animation_player.play("close")
			elif not closed and not val:
				# false -> false
				pass
		closed = val
	get: return closed


@export var has_drink: bool:
	set(val):
		if val:
			if drink:
				drink.show()
		else:
			if drink:
				drink.hide()
		has_drink = val
	get: return has_drink


func _ready() -> void:
	has_drink = true
	closed = true
