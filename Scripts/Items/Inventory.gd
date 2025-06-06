class_name Inventory extends Resource

@export var items: Array[Item]




func add_item(item: Item) -> void:
	if not item.name == "Cash":  ## NOTE: All cash items just change balance and are not added to inv
		if not Global.limit_capcity:
			items.append(item)
		else:
			if max(items.size() + 1, Global.MAX_INVENTORY_SIZE) == Global.MAX_INVENTORY_SIZE:
				items.append(item)


func remove_item(item: Item) -> void:
	if items.has(item):
		var index = items.find(item)
		items.remove_at(index)


func combine_items(item1: PartialItem, item2: PartialItem) -> bool:
	if Global.ItemDB.get_item_combo_result(item1, item2) != null:
		var result: Item = Global.ItemDB.get_item_combo_result(item1, item2)
		add_item(result)
		remove_item(item1)
		remove_item(item2)
		
		return true
	else:
		return false


func size() -> int:
	return items.size()


func clear() -> void:
	items.clear()


func get_item_at_index(id: int):
	if range(items.size()).has(id):
		return items[id] as Item
	return null



func get_value_counts() -> Dictionary:
	if not items.is_empty():
		var result = {}
		for i in items:
			if i not in result.keys():
				result[i] = 1
			else:
				result[i] += 1
	
		return result
	return {}
