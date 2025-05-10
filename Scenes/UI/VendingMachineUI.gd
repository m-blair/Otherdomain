extends HUDElement

const OUT_OF_STOCK_COLOR = Color("#23232386")
const IN_STOCK_SELECTED_COLOR = Color.WHITE
const IN_STOCK_UNSELECTED_COLOR = Color.GRAY

# main containers
@onready var buttons: VBoxContainer = $Buttons
@onready var price_labels: VBoxContainer = $PriceLabels
@onready var stock_lights: VBoxContainer = $StockLights


# sfx
@onready var beep: AudioStreamPlayer = $beep
@onready var click: AudioStreamPlayer = $click
@onready var door_open: AudioStreamPlayer = $door_open
@onready var door_shut: AudioStreamPlayer = $door_shut

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# dynamic labels
@onready var cash: Label = $Cash
@onready var balance: Label = $Balance



# buttons
@onready var reset_button: Button = $ResetButton
@onready var exit_button: Button = $ExitButton

# visual only
@onready var bill_slot_texture: TextureRect = $BillSlotTexture
@onready var hover_rect: ReferenceRect = $BillSlotTexture/HoverRect
@onready var money: Sprite2D = $Money
@onready var outline: ReferenceRect = $Money/Outline
@onready var money_2: Sprite2D = $Money2

var DEFAULT_SPRITE_POS = Vector2(1536, -48)

var vm: VendingMachine
var player: Player
var showing_product_names: bool = true
var holding_cash: bool = false
var paying: bool = false
var SELECTED_ITEM = null
var stuck: bool = false

# 'player.player_data.balance' at the start of this interaction
var starting_cash := 0.0

# paid amount - selected.cost
var credit_total: float:
	set(value):
		credit_total = value
		if balance:
			if credit_total <= 0:
				balance.add_theme_color_override("font_color", Color.WHITE)
			elif credit_total > 0:
				balance.add_theme_color_override("font_color", Color.LIME)
	get(): return credit_total

var setup_complete: bool = false

signal cash_inserted(amount: float)
signal item_selected(id: int)



func _process(delta: float) -> void:
	if setup_complete:
		if holding_cash:
			money.position = get_global_mouse_position()
		else:
			money.position = DEFAULT_SPRITE_POS



func setup() -> void:
	DEFAULT_SPRITE_POS = money.position
	player = GameState.player
	starting_cash = player.player_data.balance
	credit_total = 0
	balance.set_text("$ %.2f" % credit_total)
	cash.set_text("$ %.2f" % starting_cash)
	print("Stocking...")
	for n in range(vm.stock.keys().size()):
		var button = buttons.get_child(n) as Button
		var label = price_labels.get_child(n) as RichTextLabel
		var color_rect = stock_lights.get_child(n) as ColorRect
		var item = vm.get_product(n) as Med
		#print(item.name)
		var quantity = vm.stock[n] as int
		var in_stock = true if quantity > 0 else false
		# connect signals to button controls
		button.pressed.connect(_on_selected_item.bind(n))
		button.disabled = true if not in_stock else false
		if in_stock:
			label.text = "[b]$[/b] %.2f" % item.price 
		else:
			label.text = ""
		color_rect.color = IN_STOCK_UNSELECTED_COLOR if in_stock else OUT_OF_STOCK_COLOR
	setup_complete = true


func reset_ui() -> void:
	balance.set_text("$ 0.00")
	if starting_cash != player.player_data.balance:
		if credit_total > 0:
			player.player_data.balance += credit_total
	credit_total = 0
	cash.set_text("$ %.2f" % starting_cash)
	SELECTED_ITEM = null
	holding_cash = false
	money_2.hide()
	money.position = DEFAULT_SPRITE_POS
	animation_player.play("RESET")
	paying = false
	stuck = false
	vm.selection = vm.DrinkType.NONE
	


func update_ui() -> void:
	for n in range(vm.stock.keys().size()):
		var button = buttons.get_child(n) as Button
		var label = price_labels.get_child(n) as RichTextLabel
		var color_rect = stock_lights.get_child(n) as ColorRect
		var item = vm.get_product(n) as Med
		var quantity = vm.stock[n] as int
		
		var in_stock = true if quantity > 0 else false
		
		if not showing_product_names:
			button.set_text("")
			
		button.disabled = true if not in_stock else false
		if in_stock:
			label.text = "$ %.2f" % item.price 
		else:
			label.text = ""
		
		if SELECTED_ITEM != null and n == SELECTED_ITEM:
			color_rect.color = IN_STOCK_SELECTED_COLOR if in_stock else OUT_OF_STOCK_COLOR
		else:
			color_rect.color = IN_STOCK_UNSELECTED_COLOR if in_stock else OUT_OF_STOCK_COLOR
		
		if SELECTED_ITEM == n:
			color_rect.color = IN_STOCK_SELECTED_COLOR
		
		balance.text = "$ %.2f" % credit_total

func get_row(id: int) -> Array[Control]:
	var button = buttons.get_child(id) as Button
	var label = price_labels.get_child(id) as RichTextLabel
	var color_rect = stock_lights.get_child(id) as ColorRect
	return [button, label, color_rect]


func get_price(id: int) -> float:
	var product: Med = vm.inventory.items[id]
	return product.price


func inside_bill_slot() -> bool:
	return bill_slot_texture.get_global_rect().has_point(get_global_mouse_position())




func _on_selected_item(id: int) -> void:
	var m = vm.get_product(id) as Med
	print(m.name)
	click.play()
	beep.play()
	if SELECTED_ITEM == id:
		#credit_total = 0
		SELECTED_ITEM = null
		vm.selection = vm.DrinkType.NONE
	
	else:
		vm.selection = id
		credit_total -= m.price
		SELECTED_ITEM = id
	
	
	var color_rect: ColorRect = stock_lights.get_child(id)
	color_rect.color = IN_STOCK_SELECTED_COLOR
	update_ui()

	#update_lights(id)





func _on_bill_slot_mouse_entered() -> void:
	# ignore if not holding cash
	hover_rect.show()
	if holding_cash:
		# accept the cash
		paying = true
	


func _on_bill_slot_mouse_exited() -> void:
	hover_rect.hide()
	paying = false
		



func _on_reset_button_pressed() -> void:
	click.play()
	if SELECTED_ITEM != null: SELECTED_ITEM = null
	credit_total = 0
	balance.set_text("$ 0.00")
	cash.set_text("$ %.2f" % starting_cash)
	update_ui()


func _on_cash_button_button_down() -> void:
	holding_cash = true
	







func _on_cash_button_button_up() -> void:
	# paying is when holding_cash and over the bill_slot
	if paying:
		# signal vend
		if randf_range(0, 1) > 0.99:
			# very small chance of money getting stuck
			print("oops... got stuck. hit RETURN")
			animation_player.play("pay2")
			stuck = true
		else:

			animation_player.play("pay1")
			cash_inserted.emit(1.00)
	else:
		print("cancelled payment")
	
	update_ui()
	money.position = DEFAULT_SPRITE_POS
	
	holding_cash = false


func _on_cash_button_mouse_entered() -> void:
	outline.show()


func _on_cash_button_mouse_exited() -> void:
	outline.hide()


func _on_cash_inserted(amount: float) -> void:
	print("$%.2f" % amount)
	
	credit_total += amount
	if SELECTED_ITEM:
		var prod: Med = vm.get_product(SELECTED_ITEM)
		print("VENDING... %s" % prod.name)
		vm.vend.emit(prod)
		player.player_data.balance -= amount
	balance.text = "$ %.2f" % credit_total
	cash.text = "$ %.2f" % player.player_data.balance
	
