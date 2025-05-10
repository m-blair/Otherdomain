extends Room


@onready var watcher: Watcher = $Watcher
@onready var dialogue_text_balloon: DialogueTextBalloon = $DialogueTextBalloon

#player.in_dialogue = true
			#print("Player interacted with %s" % character)
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#dialogue_text_balloon.start(dialogue_text_balloon.resource, "INTRODUCTION")
			#await dialogue_text_balloon.done
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#player.in_dialogue = false
#
#func _ready() -> void:
	#dialogue_text_balloon.done.connect(_on_dialogue_finished)

#func _ready() -> void:
	#watcher.inter


#func 

func _on_watcher_interacted() -> void:
	print("watcher dialogue")
	player.in_dialogue = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	dialogue_text_balloon.start(dialogue_text_balloon.resource, "INTRODUCTION")
	await dialogue_text_balloon.done
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.in_dialogue = false
