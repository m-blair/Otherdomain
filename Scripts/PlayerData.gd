class_name PlayerData
extends Node

var player: Player

@export var current_room: String
@export var inventory: Inventory
## How much $$$ player has in their wallet
@export_range(0.0, 99999.99, 0.01, "suffix:$") var balance: float = 0.0

@export var dialogue_history: Dictionary
# 'met': has player talked to them at least once?
# 'lines_used': what dialogue lines have already been used
# 'score': [Player_score, Entity_score] (in games)

var objects = ["Vending Machine", "Pyramid Of Truth", "Obelisk Of Lies", "ItemDrop", "Door"]



func _setup() -> void:
	for char_name in Global.characters.keys():
		if char_name in Global.characters.keys() and not char_name in Global.chars_to_ignore:
			dialogue_history[char_name] = {"met": false, "lines_used": []}
			
			if char_name in Global.entities:
				# track scores for games against entities
				dialogue_history[char_name]["score"] = []
		
	for obj in objects:
		if obj not in dialogue_history.keys():
			dialogue_history[obj] = {"met": false, "lines_used": []}




func set_entity_met(entity_name: String) -> void:
	if entity_name in dialogue_history.keys():
		dialogue_history[entity_name]["met"] = true
		

func has_met_entity(entity: Entity) -> bool:
	return true if dialogue_history[entity]["met"] else false


# handling dialogue
func set_dialogue_line_used(character: String, title: String) -> void:
	print("'%s' - '%s'" % [title, character])
	print(dialogue_history)
	if dialogue_history.keys().has(character):
		if not dialogue_history[character]["lines_used"].has(title):
			dialogue_history[character]["lines_used"].append(title)
		


func has_used_dialogue(character, title) -> bool:
	return true if dialogue_history[character]["lines_used"].contains(title) else false
