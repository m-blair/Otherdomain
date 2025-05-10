class_name Item 
extends Resource

@export var name: String
enum ItemType {FILE, MAP, KEY, PARTIAL, MED, OTHER}
@export var type: ItemType
@export var usable: bool
@export var combinable: bool
@export var examinable: bool
@export_multiline var description: String
@export var icon: Texture2D
