extends AnimatedSprite3D

enum TreeType {
	Sycamore, Pine, Maple, Fir, Spruce
}
@export var tree: TreeType = TreeType.Sycamore

func _ready() -> void:
	play(TreeType.keys()[tree])
