@icon("res://Assets/Icons/Bottle Water.svg")
class_name VendingMachine
extends InteractiveObject3D

@onready var sfx: AudioStreamPlayer = $sfx
@onready var hum: AudioStreamPlayer3D = $hum



enum DrinkType {FIZZY_INVIZZY = 0, XYLOWAVE = 1, OCEAN_MIST = 2, RAZBEER_COLA = 3, ORENJI = 4, BUG_JUICE = 5, SLOP = 6, NONE = 7}
@export var selection: DrinkType

@export var using: bool = false

@export var out_of_service: bool = false 

## the current stock of this machine
@export var inventory: Inventory

var product_map: Dictionary[int, String] = {DrinkType.FIZZY_INVIZZY: "res://Assets/Resources/Items/FizzyInvizzy.tres",
DrinkType.XYLOWAVE: "res://Assets/Resources/Items/Xylowave.tres",
DrinkType.OCEAN_MIST: "res://Assets/Resources/Items/OceanMist.tres",
DrinkType.RAZBEER_COLA: "res://Assets/Resources/Items/RazbeerCola.tres", 
DrinkType.ORENJI: "res://Assets/Resources/Items/Orenji.tres", 
DrinkType.BUG_JUICE: "res://Assets/Resources/Items/BugJuice.tres",
DrinkType.SLOP: "res://Assets/Resources/Items/Slop.tres"}

# value counts of this machine's stock (how to fill it's inventory)
var stock: Dictionary = {DrinkType.FIZZY_INVIZZY: 5,
DrinkType.XYLOWAVE: 0,
DrinkType.OCEAN_MIST: 0,
DrinkType.RAZBEER_COLA: 0, 
DrinkType.ORENJI: 7, 
DrinkType.BUG_JUICE: 1,
DrinkType.SLOP: 1}

## camera angles for viewport
@onready var _11: Camera3D = $"11" ## button panel
@onready var _12: Camera3D = $"12" ## bottom opening


signal item_selected(id: int)
signal vend(product: Item)


func _ready() -> void:
	inventory = Inventory.new()
	stock_machine()
	if out_of_service:
		hum.autoplay = false
		hum.stop()


func stock_machine() -> void:
	inventory.clear()

	for i in stock.keys():
		var quantity = stock[i]
		if quantity > 0:
			for j in range(quantity):
				var item = get_product(i)
				inventory.add_item(item)




func get_product(id: int):
	var res_path: String = product_map.get(id)
	if res_path:
		var res_name: String = res_path.split("/")[-1]
		var item: Item = Global.ItemDB.get_item(res_name)
		return item
	return null
	


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		player_in_range = true
		#print("player is near Vending Machine")
		Signals.found_object.emit(self)


func _on_body_exited(body: Node3D) -> void:
	if body is Player and player_in_range:
		#print("player left vending machine")
		player_in_range = false
		Signals.left_object.emit(self)


func _on_vend(product: Item) -> void:
	print("Dispensing %s..." % product.name)
	#print("Change: $%.2f" % )
	## TODO: produce ItemPickup for the vended item and place it in the door
	await get_tree().create_timer(0.5).timeout
	sfx.play(3.74)
	await get_tree().create_timer(1.2).timeout
	sfx.stop()
	
