extends Node

var player: Player:
	set(new_player):
		print("\n\n'GameState.player' changed...\n\n")
		player = new_player
	get: return player
var current_room_id: String

var include_text_hinting: bool = false
