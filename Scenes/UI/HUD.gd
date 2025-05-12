@icon("res://Assets/Icons/Window Maximize.svg")
class_name HUD extends CanvasLayer

@onready var crosshair: Crosshair = $Crosshair

var player: Player

@onready var menu: MENU = $MENU
#@onready var mini_game_ui: MiniGameUI = $MiniGameUI
@onready var doc_reader: HUDElement = $DocReader
@onready var vending_machine_ui: HUDElement = $VendingMachineUI
@onready var control_popup: HUDElement = $ControlPopup
@onready var name_text_box: NameTextBox = $NameTextBox
@onready var hud_effects: HUDElement = $HUDEffects



var subscenes = {0: "res://Scenes/UI/VendingMachineUI.tscn"}


@onready var buttons: VBoxContainer = $VendingMachineUI/Buttons
@onready var price_labels: VBoxContainer = $VendingMachineUI/PriceLabels
@onready var stock_lights: VBoxContainer = $VendingMachineUI/StockLights

var anything_open: bool = false

var setup_complete = false

signal item_pickup_request(item_drop: ItemDrop)
signal show_vending_machine_ui(vending_machine: VendingMachine)
signal hide_vending_machine_ui(vending_machine: VendingMachine)

signal hud_effect_end

func _ready() -> void:
	menu.hide()
	player = GameState.player
	vending_machine_ui.player = GameState.player
	menu.player = GameState.player
	
	var i := 0
	
	for node in get_children():
		if node is HUDElement:
			node.hud_priority = i
			i += 1
	setup_complete = true







func any_hud_elements_open() -> bool:
	for h in get_children():
		if h is HUDElement:
			var hud_elt: HUDElement = h
			if hud_elt.open:
				return true
	return false


func anything_supressed() -> bool:
	var result = false
	for h in get_children():
		if h is HUDElement:
			var hud_elt: HUDElement = h
			if hud_elt.supressing:
				return true
	return false


func desupress_and_hide() -> void:
	for h in get_children():
		if h is HUDElement:
			var hud_elt: HUDElement = h
			if hud_elt.supressing:
				hud_elt.supressing = false
				hud_elt.hide()
			#else:
				#hud_elt.hide()



func _process(delta: float) -> void:
	if setup_complete:
		if any_hud_elements_open():
			crosshair.hide()
			anything_open = true
		else:
			crosshair.show()
			anything_open = false


func _on_show_vending_machine_ui(vending_machine) -> void:
	# this line toggles visibility too
	
	vending_machine_ui.open = true
	if control_popup.visible and not control_popup.supressing:
		control_popup.supressing = true



func _on_menu_doc_reader_open_request(item: Item) -> void:
	control_popup.supressing = true if control_popup.visible else false
	doc_reader.preload_item(item)
	doc_reader.show()
	await doc_reader.closed
	menu.boodoowoop_reversed.play()
	control_popup.hide()




func _show_name_text_box(thing: Variant) -> void:
	name_text_box.show_name(thing)


func _on_hide_name_text_box() -> void:
	name_text_box.hide_name()



func _on_item_pickup_request(item_drop: ItemDrop) -> void:
	print("pickup request %s" % item_drop.item.name)
	player.player_data.inventory.add_item(item_drop.item)
	menu.load_inventory()
	menu.boodoowoop.play()
	control_popup.hide_control_popup.emit()
	#GameState.player.player_data.inventory.add_item()
	item_drop.picked_up.emit()


func _on_item_used(item: Item) -> void:
	menu._close()
	print("Used %s" % item.name)
