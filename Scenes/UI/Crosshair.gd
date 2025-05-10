class_name Crosshair extends Sprite2D


@onready var color_rect: ColorRect = $ColorRect
@onready var color_rect_2: ColorRect = $ColorRect2
@onready var crosshair_animator: AnimationPlayer = $CrosshairAnimator



enum CrosshairType {CROSS, DOT, HIDDEN, X}
@export var type: CrosshairType:
	set(t):
		t = type
		set_type(t)


func set_type(t: CrosshairType) -> void:
	if crosshair_animator:
		match t:
			CrosshairType.CROSS:
				crosshair_animator.play("CROSS")
			CrosshairType.DOT:
				crosshair_animator.play("DOT")
			CrosshairType.HIDDEN:
				crosshair_animator.play("HIDDEN")
			CrosshairType.X:
				crosshair_animator.play("X")
