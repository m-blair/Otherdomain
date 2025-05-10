extends Room


@onready var beep_001: AudioStreamPlayer = $Beep001


@onready var dialogue_text_balloon: DialogueTextBalloon = $DialogueTextBalloon

#@onready var rps_guy: RPSGuy = $RPSGuy
#@onready var rps_guy_2: RPSGuy = $RPSGuy2

@onready var pyramid_of_truth: PyramidOfTruth = $PyramidOfTruth
@onready var vending_machine: VendingMachine = $VendingMachine
@onready var vending_machine_2: VendingMachine = $VendingMachine2

@onready var hans: RPSGuy = $RPSGuy


#func _ready() -> void:
	#GameState.player = player
	#GameState.current_room_id = room_id
	#dialogue_text_balloon.done.connect(_on_dialogue_finished)
	#hans.rps_guy_animation_player.play("idling")


#func interact_with(character: String):
	#match character:
		#"RPSGuy1":
			#player.in_dialogue = true
			#print("Player interacted with %s" % character)
			##Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#rps_guy.rps_guy_animation_player.play("handshake")
			#rps_guy_2.rps_guy_animation_player.play("handshake")
			#await rps_guy_2.rps_guy_animation_player.animation_finished
			##Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#player.in_dialogue = false
		#"RPSGuy2":
			#player.in_dialogue = true
			#print("Player interacted with %s" % character)
			##Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#rps_guy.rps_guy_animation_player.play("handshake")
			#rps_guy_2.rps_guy_animation_player.play("handshake")
			#await rps_guy_2.rps_guy_animation_player.animation_finished
			##Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#player.in_dialogue = false
		#"Watcher":
			#player.in_dialogue = true
			#print("Player interacted with %s" % character)
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#dialogue_text_balloon.start(dialogue_text_balloon.resource, "INTRODUCTION")
			#await dialogue_text_balloon.done
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#player.in_dialogue = false
		#"Pyramid Of Truth":
			#print("Player interacted with %s" % character)
		#"Obelisk Of Lies":
			#print("Player interacted with %s" % character)
		#"VendingMachine":
			#print("VM!")





func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("DEBUG player reset") and player.position != spawn_point.position:
		beep_001.play()
		player.position = spawn_point.position
