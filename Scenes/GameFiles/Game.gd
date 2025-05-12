class_name Game extends Node3D

@export var current_room: Room
var hud = preload("res://Scenes/UI/HUD.tscn").instantiate() as HUD

enum InteractionType {ENTITY, OBJECT}

## TODO: 
## player data loading
## room construction / changing
## game-to-HUD signal connections

var player: Player # reference
#var TEST_INVENTORY = preload("res://Assets/Resources/TestInventory.tres") as Inventory
var PAPERCLIP = preload("res://Assets/Resources/Items/Paperclip.tres") as PartialItem
var ENTITY_ENCYCLOPEDIA = preload("res://Assets/Resources/Items/Entity-Encyclopedia.tres")

signal room_change(room_id: StringName, next_door_id: int)
signal room_loaded
signal balance_changed(amount: float, new_balance: float)


func _ready() -> void:
	Global.game = self
	var new_player: Player = Player.new()
	new_player.player_data = PlayerData.new()
	new_player.player_data._setup()
	new_player.player_data.inventory = Inventory.new()
	new_player.player_data.current_room = &"Hub"
	new_player.player_data.balance = 0.00
	
	
	GameState.player = new_player
	
	player = new_player
	if get_tree().get_first_node_in_group("Player"):
		player = get_tree().get_first_node_in_group("Player")
	#player = GameState.player
	#var inv: Inventory = Inventory.new()
	#inv.add_item(PAPERCLIP)
	#inv.add_item(ENTITY_ENCYCLOPEDIA)
	#GameState.player.player_data.inventory = inv
	#player.player_data.inventory = inv
	#player.player_data.balance = 15.0
	#GameState.player.player_data.balance = 15.0
	setup_room()
	add_child(hud)
	connect_global_signals()
	hud.menu.player = GameState.player
	hud.menu.load_inventory()
	hud.crosshair.type = hud.crosshair.CrosshairType.CROSS
	

func setup_room() -> void:
	current_room = get_child(0) as Room
	#GameState.player_data.current_room = current_room.room_id
	#player.player_data.current_room = current_room.room_id
	for node in current_room.get_children():
		if node is ItemDrop:
			node.fill_item_data(node.item)
		#if node is Door:
			#node.


func connect_global_signals() -> void:
	Signals.found_object.connect(_on_object_found)
	Signals.left_object.connect(_on_object_left)
	Signals.found_entity.connect(_on_entity_found)
	Signals.left_entity.connect(_on_entity_left)
	player.interaction_manager.interacted.connect(_on_player_interacted)
	hud.control_popup.show_control_popup.connect(hud.control_popup._on_show_popup)
	hud.control_popup.hide_control_popup.connect(hud.control_popup._on_hide_popup)
	hud.name_text_box.show_text_box.connect(hud.name_text_box.show_name)
	hud.name_text_box.hide_text_box.connect(hud.name_text_box.hide_name)
	Signals.exited_room.connect(_on_room_left)
	Signals.entered_room.connect(_on_room_entered)
	balance_changed.connect(_on_balance_changed)


func interact_with_object(object: InteractiveObject3D) -> void:
	# player pressed a key on an interactive object 
	# (NOTE: this is DIFFERENT than when the player comes in range of the object
	# which causes the ui elements to show)
	if object is VendingMachine:
		var vm: VendingMachine = object
		if not vm.out_of_service:
			vm.using = true
			hud.vending_machine_ui.vm = vm
			if not hud.vending_machine_ui.exit_button.pressed.is_connected(_on_vending_machine_ui_exited):
				hud.vending_machine_ui.setup()
				hud.vending_machine_ui.exit_button.pressed.connect(_on_vending_machine_ui_exited.bind(vm))
			hud.vending_machine_ui.update_ui()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			vm._11.make_current()
			hud.show_vending_machine_ui.emit(vm)
		else:
			hud.control_popup.show_control_popup.emit("E", "INTERACT", ["OUT OF ORDER"])
	elif object is PyramidOfTruth:
		#print("PYRAMID OF TRUTH")
		hud.control_popup.show_control_popup.emit("E", "INTERACT", ["PYRAMID OF TRUTH"])
	elif object is ObeliskOfLies:
		#print("OBELISK OF LIES")
		hud.control_popup.show_control_popup.emit("E", "INTERACT", ["OBELISK OF LIES"])
	elif object is BasicDoor or object is WoodenDoor:
		print(["Locked: %s" % str(object.locked)])
		var door: Door = object
		if door.locked:
			## show locked text on first enter try 
			if not door.lock_hint_seen:
				hud.control_popup.show_control_popup.emit("E", "ENTER", [door.locked_hint])
				door.lock_hint_seen = true
			
		elif door.open:
			## open door and transition to next room
			print("\n\n")
			#door.open_sfx.play()
			hud.hud_effects.fade_out.emit(Color.BLACK)
			await hud.hud_effects.effect_finished
			Signals.exited_room.emit(door.next_room_id, door.next_door_id)
			
			
	elif object is ItemDrop:
		print("item pickup request")
		hud.item_pickup_request.emit(object)
		handle_item_drop(object as ItemDrop)


func handle_item_drop(item_drop: ItemDrop) -> void:
	
	var item: Item = item_drop.item
	
	if item is OtherItem and item.name == "Cash":
		var new_bal = GameState.player.player_data.balance + item.value
		GameState.player.player_data.balance = new_bal
		balance_changed.emit(item.value, new_bal)
		
	elif item is File:
		hud.menu.doc_reader_open_request.emit(item)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		await hud.doc_reader.closed
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	


func _on_entity_found(entity: Entity) -> void:
	# when player walks up to an entity
	hud.name_text_box.show_text_box.emit(entity)
	if entity is Wanderer:
		pass
	elif entity is Watcher:
		if entity.near_player:
			hud.control_popup.show_control_popup.emit("E", "TALK")
	elif entity is RPSGuy:
		if entity.near_player: 
			hud.control_popup.show_control_popup.emit("E", "TALK")
	
	else:
		print("Entity '%s' doesn't have this functionality yet" % entity.name)



func _on_entity_left(entity: Entity) -> void:
	if hud.anything_supressed():
		hud.desupress_and_hide()
	if hud.name_text_box.visible:
		hud.name_text_box.hide_text_box.emit()
	
	if entity is RPSGuy:
		var hans: RPSGuy = entity
		hans.rps_guy_animation_player.play("peace out")
		await hans.rps_guy_animation_player.animation_finished
		hans.rps_guy_animation_player.play("default1")
		hans.opponent = null
		
		if hans.playing:
			hans.playing = false




func interact_with_entity(entity: Entity) -> void:
	# when player presses the specified action key on an entity within range
	print(entity.name)
	if entity is Wanderer:
		pass
	elif entity is Watcher:
		if entity.near_player:
			# initiate dialogue
			pass
			
	elif entity is RPSGuy:
		if entity.near_player: 
			# initiate Rock paper scissors game here
			entity.playing = true
			entity.opponent = player
			# signal open RPS UI here
			#hud.show_mini_game_ui.emit(hud.mini_game_ui.MiniGames.RPS)



func _on_player_interacted(collider) -> void:
	var node = collider.owner
	if node is InteractiveObject3D:
		var obj = node as InteractiveObject3D
		interact_with_object(obj)
		
	elif node is Entity:
		var entity = node as Entity
		interact_with_entity(entity)


func _on_room_left(next_room_id: StringName, next_door_id: int) -> void:
	print("room change...")
	if current_room:
		if not current_room.doors.is_empty():
			current_room.doors[0].close_sfx.play()
	room_change.emit(next_room_id, next_door_id)


func _on_room_entered(next_door_id: int) -> void:
	if current_room:
		if not current_room.doors.is_empty():
			player = current_room.player
			current_room.doors[0].close_sfx.play()
	
	print(player.interaction_manager.interacted.is_connected(_on_player_interacted))
	if not player.interaction_manager.interacted.is_connected(_on_player_interacted):
		print("reconnecting signal")
		player.interaction_manager.interacted.connect(_on_player_interacted)
		
	setup_room()
	#connect_global_signals()
	room_loaded.emit()
	print("entering %s..." % current_room.room_id)
	current_room.set_entry_pos(next_door_id) # move the player to the correct side of the door in the next room



func _on_object_left(object) -> void:
	hud.control_popup.hide_control_popup.emit()
	if hud.name_text_box.visible:
		hud.name_text_box.hide_text_box.emit()



func _on_object_found(object) -> void:

	if object is ItemDrop:
		hud.name_text_box.show_text_box.emit(object)
		hud.control_popup.show_control_popup.emit("E", "PICK UP")
	elif object is Door:
		print(object.name)
		hud.control_popup.show_control_popup.emit("E", "ENTER")
	else:
		print(object.name)
		hud.control_popup.show_control_popup.emit("E", "INTERACT")



func _on_vending_machine_ui_exited(vending_machine: VendingMachine) -> void:
	hud.vending_machine_ui.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	vending_machine._11.current = false
	hud.vending_machine_ui.open = false
	if hud.control_popup.supressing:
		hud.control_popup.open = false
	vending_machine.using = false
	print("exited VM")


func _on_balance_changed(amount_added: float, new_bal: float) -> void:
	print("player balance changed")
	hud.menu.update_player_data(new_bal)
	hud.hud_effects.flash_cash_text.emit(amount_added)
