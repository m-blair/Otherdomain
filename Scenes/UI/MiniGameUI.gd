class_name MiniGameUI extends HUDElement

@export var p1: Player
@export var p2: Entity

enum MiniGames {RPS, STARING_CONTEST, CHESS, NONE}
@export var current_mini_game: MiniGames:
	set(new_game):
		current_mini_game = new_game
		if new_game != MiniGames.NONE:
			show_mini_game(new_game)
		else:
			playing = false
			hide_all()
	get: return current_mini_game


@export var playing: bool = false


# utility nodes
@onready var stopwatch: Stopwatch = $Stopwatch



# minigame subscenes
@onready var staring_contest: Control = $StaringContest



@onready var rps: Control = $RPS
@onready var options: ItemList = $RPS/Options




@onready var chess: Control = $Chess

# subscene anim. player nodes
@onready var staring_contest_animator: AnimationPlayer = $StaringContest/StaringContestAnimator



signal mini_game_started(game: int)
signal mini_game_ended

func _ready() -> void:
	pass




func fill_player_details(mini_game: int) -> void:
	# fill in labels and stuff with p1, p2 details
	pass


func start(mini_game: int) -> void:
	current_mini_game = mini_game
	fill_player_details(mini_game)
	show_mini_game(mini_game)
	playing = true




func hide_all() -> void:
	for node in get_children():
		if node is Control:
			node.hide()


func show_mini_game(new_game: int) -> void:
	for node in get_children():
		if node is Control:
			var index = node.get_index()
			if index == new_game:
				node.show()
			else:
				node.hide()



func _reset() -> void:
	current_mini_game = MiniGames.NONE
	hide_all()


func _on_exit_pressed() -> void:
	_reset()
	playing = false
	print("Ending mini-game...")
	mini_game_ended.emit()


func _on_rps_round_lost(player: Variant) -> void:
	pass # Replace with function body.


func _on_mini_game_started(game: int) -> void:
	start(game)
