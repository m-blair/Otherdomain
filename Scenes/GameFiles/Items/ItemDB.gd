extends Node
## FILE FOR CREATING ACTUAL GAME ITEMS OUT OF RESOURCES.


## holds custom item resources in global scope
@export var cache: Dictionary = {}

## keeps track of every item's type: item_type: [item1_name, item2_name, ...]
@export var resource_dict: Dictionary = {}


const item_folder = "res://Assets/Resources/Items/"


func _ready():
	get_all_items_in_subfolder(item_folder)

## caches all items of the subtype associated with the folder passed
func get_all_items_in_subfolder(item_subfolder):
	var folder = DirAccess.open(item_subfolder)
	folder.list_dir_begin()
	var file_name = folder.get_next()
	
	while file_name != "":
		var item = load(item_subfolder + "/" + file_name)
		## map item.name to its resource_name (so that info about the item can be looked up later)
		
		if not ".tres" in file_name:
			file_name = folder.get_next()
			continue
		
		resource_dict[item.name] = file_name
		
		## add item to the cache (for later reference)
		cache[file_name] = item
		
		file_name = folder.get_next()
		
		



func get_all_item_names():
	var names = []
	for k in resource_dict.keys():
		if not "blank" in k:
			var new_name: String = str(k)
			#new
			names.append(new_name)
	return names






## ITEM GENERATION =============================================================


func get_item_resource_id(item_name: String) -> String:
	## returns item's ID property, given its NAME property
	return resource_dict[item_name]


func get_item_by_res_name(item_res_name: String) -> Item:
	## returns the associated item when provided the name used as its key in 'cache'
	if ".tres" in item_res_name:
		item_res_name = item_res_name.replace(".tres", "")
	return get_item(item_res_name)


## arg match the item's NAME property, not ID
func get_item(NAME) -> Item:
	return cache[NAME]


func get_random_item() -> Item:
	## returns a random item, regardless of whether the player has it already
	var item_names = get_all_item_names()
	var rand_index: int = randi_range(0, item_names.size() - 1)
	var rand_item: Item = get_item(item_names[rand_index])
	return rand_item


## this is potentially dangerous code, do not call when loading with all items in player's inventory
func get_new_random_item(item_list: Array):
	## returns a random item that is not currently in the player's inventory
	var rand_item: Item = get_random_item()
	while rand_item in item_list:
		rand_item = get_random_item()
	return rand_item




## ITEM - RELATED HELPER METHODS =============================================================

func get_item_type_color(item_type: String):
	match item_type:
		"File":
			return "#4797a0"
		"Map":
			return "#7d86ff"
		"Key":
			return "#d47e1d"
		"Tool":
			return "#e7b000"
		"Weapon":
			return "c3003b"
		"Heal":
			return "lime"
		"Partial":
			return "gray"
		"Ammo":
			return "red"
		_:
			# default to white
			return "white"




func get_item_combo_result(item1: PartialItem, item2: PartialItem):
	var both_combineable: bool = item1.combinable and item2.combinable
	var valid_combo: bool = item1.combo_id == item2.combo_id
	var same_combo_result: bool = item1.result == item2.result
	
	if both_combineable and valid_combo and same_combo_result:
		var name_: String = item1.result.resource_path.split("/")[-1]
		var result: Item = get_item(name_)
		return result
	
	print("Invalid Combo '%s' and '%s'" % [item1.name, item2.name])
	return null
