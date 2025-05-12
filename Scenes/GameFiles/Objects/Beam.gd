extends Node3D

@onready var mesh: MeshInstance3D = $Mesh
var BEAM = preload("res://Assets/Materials/Beam.tres")
@export var beam_color: Color:
	set(new_color):
		if mesh:
			mesh.mesh.material.albedo_color = new_color
