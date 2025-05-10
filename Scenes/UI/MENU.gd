class_name MENU extends HUDElement



#SFX
@onready var blup: AudioStreamPlayer = $Blup
@onready var typewriter_tick: AudioStreamPlayer = $TypewriterTick
@onready var booweep: AudioStreamPlayer = $Booweep
@onready var decide: AudioStreamPlayer = $Decide


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hud: HUD = $".."


# tab buttons
@onready var tabs: VBoxContainer = $Panel/Tabs
@onready var status: Button = $Panel/Tabs/Status
@onready var items: Button = $Panel/Tabs/Items
@onready var map: Button = $Panel/Tabs/Map
@onready var options: Button = $Panel/Tabs/Options
@onready var exit: Button = $Panel/Tabs/Exit

# subscenes
@onready var menu_region: Control = $Panel/MenuRegion
@onready var status_tab: Control = $Panel/MenuRegion/StatusTab
@onready var item_tab: Control = $Panel/MenuRegion/ItemTab
@onready var map_tab: Control = $Panel/MenuRegion/MapTab
@onready var options_tab: Control = $Panel/MenuRegion/OptionsTab


# MENU Controls
@onready var item_list: ItemList = $Panel/MenuRegion/ItemTab/ItemList
@onready var use: Button = $Panel/MenuRegion/ItemTab/VBoxContainer/Use
@onready var examine: Button = $Panel/MenuRegion/ItemTab/VBoxContainer/Examine
@onready var combine: Button = $Panel/MenuRegion/ItemTab/VBoxContainer/Combine

@onready var item_details_box: Panel = $Panel/MenuRegion/ItemTab/ItemDetailsBox
@onready var item_icon: TextureRect = $Panel/MenuRegion/ItemTab/ItemDetailsBox/ItemIcon
@onready var item_name: RichTextLabel = $Panel/MenuRegion/ItemTab/ItemDetailsBox/ItemName
@onready var description: Label = $Panel/MenuRegion/ItemTab/ItemDetailsBox/Description
@onready var item_type: Label = $Panel/MenuRegion/ItemTab/ItemDetailsBox/ItemType

@onready var boodoowoop: AudioStreamPlayer = $Boodoowoop
@onready var boodoowoop_reversed: AudioStreamPlayer = $BoodoowoopReversed


@onready var balance_label: Label = $Panel/MenuRegion/StatusTab/BalanceLabel
@onready var name_label: RichTextLabel = $Panel/MenuRegion/StatusTab/NameLabel



var player: Player
var can_use_item: bool = false

enum TABS {
	STATUS,
	ITEMS,
	MAP,
	OPTIONS
}


var SELECTED_ITEM = null
var FIRST_ITEM = null
var SELECTED_ITEM_INDEX = null
var COMBINING: bool = false

var current_tab = 0


signal item_use_attempt(item: Item)
signal doc_reader_open_request(item: Item)


func load_inventory() -> void:
	item_list.clear()
	var j := 0
	for i in player.player_data.inventory.items:
		var item: Item = i
		item_list.add_item(item.name, item.icon)
		item_list.set_item_tooltip_enabled(j, false)
		j += 1


func show_side_buttons(item) -> void:
	use.disabled = true if not item.usable else false
	examine.disabled = false if item is File else true 
	combine.disabled = true if not item.combinable else false
	


func update_player_data(new_bal: float) -> void:
	balance_label.text = "$ %05.2f" % new_bal



func _open() -> void:
	#player = GameState.player
	decide.play()
	animation_player.play("open")
	await animation_player.animation_finished
	open = true


func _close() -> void:
	blup.play()
	animation_player.play("close")
	await animation_player.animation_finished
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	open = false


func _ready() -> void:
	ordering = "First"
	clear_item_details_box()
	connect_tab_menu()
	open = false








func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu") and not open and not hud.any_hud_elements_open():
		_open()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	elif Input.is_action_just_pressed("menu") and open:
		_close()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		




func connect_tab_menu() -> void:
	for i in range(tabs.get_child_count() - 1):
		var button: Button = tabs.get_child(i)
		button.toggled.connect(_on_tab_selected.bind(i))

func toggle_off_others(id: int) -> void:
	var i := 0
	for t in tabs.get_children():
		if t is Button:
			if t.button_pressed and i != id:
				t.set_pressed_no_signal(false)
			i += 1


func reset_tabs() -> void:
	for t in tabs.get_children():
		if t is Button and t.button_pressed:
			t.set_pressed_no_signal(false)
	
	for control in menu_region.get_children():
		if control.visible:
			control.hide()



func get_item_text_color(item: Item) -> Color:
	return Global.ITEM_TYPE_COLORS[item.type] if item.type in Global.ITEM_TYPE_COLORS.keys() else Color.WHITE
	




func fill_item_details_box(item: Item) -> void:
	item_icon.texture = load(item.icon.resource_path)
	item_name.set_text("[pulse]%s[/pulse]" % item.name.to_upper())
	description.text = item.description
	item_type.add_theme_color_override("font_color", get_item_text_color(item))
	item_type.set_text("TYPE: %s" % item.ItemType.keys()[item.type])
	#read_file.show() if item.type == Item.ItemType.FILE else read_file.hide()
	item_details_box.show()

func clear_item_details_box() -> void:
	item_icon.texture = null
	item_name.set_text("")
	description.text = ""
	#read_file.hide()
	item_details_box.hide()


func show_tab(id: int) -> void:
	for i in range(menu_region.get_child_count()):
		if i == id:
			menu_region.get_child(i).show()
		else:
			menu_region.get_child(i).hide()


func get_tab_name(id: int) -> String:
	return tabs.get_child(id).name



func _on_tab_selected(toggled_on: bool, index: int) -> void:
	if current_tab != index:
		if toggled_on:
			# new selection (non-reselect)
			current_tab = index
			toggle_off_others(index)
			show_tab(index)
			menu_region.show()
			booweep.play()
		else:
			current_tab = null
			reset_tabs()
			menu_region.hide()
	else:
		current_tab = null
		reset_tabs()
		menu_region.hide()




func get_item(id: int):
	return player.player_data.inventory.get_item_at_index(id)




func _on_close_pressed() -> void:
	blup.play()
	reset_tabs()
	_close()








func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var selection: Item = get_item(index)
	var button: int = mouse_button_index
	
	
	if SELECTED_ITEM != null and selection != SELECTED_ITEM:
		
		
		if COMBINING and FIRST_ITEM:
			if selection is PartialItem:
				if player.player_data.inventory.combine_items(FIRST_ITEM, selection):
					# combo success
					load_inventory()
					booweep.play()
					
			COMBINING = false
			SELECTED_ITEM = null
			SELECTED_ITEM_INDEX = null
			item_list.deselect_all()
			use.disabled = true
			examine.disabled = true
			combine.disabled = true
			clear_item_details_box()
			print("---%s" % selection.name)
		else:
			decide.play()
			SELECTED_ITEM = selection
			SELECTED_ITEM_INDEX = index
			show_side_buttons(selection)
			fill_item_details_box(selection)
			print("%s" % selection.name)
		
	elif SELECTED_ITEM != null and selection == SELECTED_ITEM:
		blup.play()
		SELECTED_ITEM = null
		SELECTED_ITEM_INDEX = null
		item_list.deselect_all()
		use.disabled = true
		examine.disabled = true
		combine.disabled = true
		clear_item_details_box()
		print("---%s" % selection.name)
	
	elif SELECTED_ITEM == null: 
		decide.play()
		SELECTED_ITEM = selection
		SELECTED_ITEM_INDEX = index
		show_side_buttons(selection)
		fill_item_details_box(selection)
		print("%s" % selection.name)
	






func _on_examine_pressed() -> void:
	if SELECTED_ITEM != null:
		if SELECTED_ITEM is File:
			boodoowoop.play()
			doc_reader_open_request.emit(SELECTED_ITEM)
			
		else:
			pass


func _on_combine_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if SELECTED_ITEM != null and SELECTED_ITEM is PartialItem:
			COMBINING = true
			FIRST_ITEM = SELECTED_ITEM
		
	else:
		COMBINING = false
		FIRST_ITEM = null



func _on_use_pressed() -> void:
	if SELECTED_ITEM != null and SELECTED_ITEM.usable:
		item_use_attempt.emit(SELECTED_ITEM)
