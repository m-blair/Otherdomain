@icon("res://Assets/Icons/Window Maximize.svg")
class_name HUDElement extends Control

@export var subscene_id: int

## The optimal order for this node in the HUD tree 
## 
@export_enum("Last", "First", "Not Last") var ordering: String

@export var open: bool:
	set(value):
		open = value
		visible = value
	get(): return open


@export var hud_priority: int

## when HUD is overriding the visibility of this node (because another HUDElement is open and takes priority)
var supressing: bool:
	set(value):
		supressing = value
		visible = not value
		open = not value
