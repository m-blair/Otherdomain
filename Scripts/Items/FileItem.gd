class_name File extends Item

@export_category("Content")
@export var title: String
@export_multiline var text: String
var pages: Dictionary[int, String]
@export var page_count: int

@export_category("Details")
## The file background texture
@export var texture: Texture2D
## Optional font to use in place of the default (Meant for translatable files)
@export var special_font: Font
## Illustrations that appear in the file (key = page_number)
@export var illustrations: Dictionary[int, Texture2D]


@export_enum("Multi", "Single") var display_type: String
