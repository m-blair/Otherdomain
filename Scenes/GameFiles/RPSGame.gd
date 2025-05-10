extends Control


@export_range(0, 3) var rounds: int = 0
var current_round: int
@export var scores: Dictionary = {0: 0, 1: 0}

var playing: bool = false


signal round_ended
signal round_won(player: int)
signal done



#func _process(delta: float) -> void:
	


func countdown():
	pass


func play() -> void:
	pass


func start_round():
	countdown()
	play()
	await round_ended



func _on_round_won(player: int) -> void:
	scores[player] += 1
	


func _on_round_ended() -> void:
	if current_round + 1 <= rounds:
		current_round += 1
	else:
		done.emit()
