extends Room

@onready var world_environment: WorldEnvironment = $WorldEnvironment


@onready var vending_machine: VendingMachine = $VendingMachine


@onready var bg_music: AudioStreamPlayer = $"bg-music"
@onready var static_hiss: AudioStreamPlayer = $"Static-hiss"
@onready var rps_guy: RPSGuy = $RPSGuy
@onready var dialogue_text_balloon: DialogueTextBalloon = $DialogueTextBalloon

@export var dialogues: Array[DialogueResource]
#var dialogues: Array[DialogueResource] = []


#func _ready() -> void:
	#pass



func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DEBUG player reset") and player.position != spawn_point.position:
		#beep_001.play()
		player.position = spawn_point.position



func interact_with(character: String):
	match character:
		"RPSGuy":
			player.in_dialogue = true
			print("Player interacted with %s" % character)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			dialogue_text_balloon.start(dialogues[0], "INTRODUCTION")
			await dialogue_text_balloon.done
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			player.in_dialogue = false
		"Watcher":
			player.in_dialogue = true
			print("Player interacted with %s" % character)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			dialogue_text_balloon.start(dialogues[2], "INTRODUCTION")
			await dialogue_text_balloon.done
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			player.in_dialogue = false



func _on_player_interacted(collider) -> void:
	if collider:
		var node: String = collider.get_parent().name
		interact_with(node)
