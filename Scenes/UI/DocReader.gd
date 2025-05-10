@icon("res://AssetLibrary/Icons/Book Open Reader.svg")
extends HUDElement

@onready var content: RichTextLabel = $Content


@onready var page_flip: AudioStreamPlayer = $PageFlip

@onready var boodoowoop: AudioStreamPlayer = $Boodoowoop
@onready var boodoowoop_reversed: AudioStreamPlayer = $BoodoowoopReversed
@onready var ploot: AudioStreamPlayer = $Ploot

@onready var file_button: Button = $Document/DocumentTexture/FileButton

@onready var animator: AnimationPlayer = $Animator
@onready var doc_animator: AnimationPlayer = $Document/DocAnimator

@onready var doc_title: Label = $DocTitle
@onready var doc: Node2D = $Document
@onready var document_texture: TextureRect = $Document/DocumentTexture
@onready var doc_page: Label = $DocPage

@onready var zoom_bar: ProgressBar = $UI/ZoomBar
@onready var zoom_slider: VSlider = $UI/ZoomBar/ZoomSlider


@onready var navigation_buttons: HBoxContainer = $UI/NavigationButtons

@onready var l: Button = $UI/NavigationButtons/L
@onready var close: Button = $UI/NavigationButtons/CLOSE
@onready var r: Button = $UI/NavigationButtons/R
@onready var examine: Button = $UI/EXAMINE



@export var current_document: File
#@export var current_map: Item
var pages = {} # enum for what text is displayed "fits" on a page
var page_count := 0
@export var current_page := 0
var setup_complete: bool = false

var blurred: bool = false

@export_enum("Multi", "Single", "Scroll", "Map") var MODE: String
## Multi  - true multi-page
## Single - true single page
## Scroll - pseudo-single page (multiple pages get merged into a single scrollable page
## Map    - same as Single (but with no text)


var dragging: bool = false
var offset_

const SNAP := 25
const HINT_SEP := "|||"
const PAGE_SEP := "<page>"
const DEFAULT_SCALE := Vector2(1, 1)


var show_hints: bool = GameState.include_text_hinting
#var opened: bool = false




signal opened(f: File)
signal closed
#signal typing_out(letter: String)
signal done_typing



func _process(_delta: float) -> void:
	if not blurred:
		file_button.disabled = false
		if dragging:
			var new_pos = document_texture.get_global_mouse_position() - (offset_ / 16)
			doc.position = Vector2(snapped(new_pos.x, SNAP), snapped(new_pos.y, SNAP))
	else:
		file_button.disabled = true
	


#func _ready() -> void:
	#preload_item(current_document)


func preload_item(item: Item) -> void:
	assert(item is File)
	if item is File:
		current_document = item
		load_document(current_document)
	
	

func load_document(document: File) -> void:
	MODE = document.display_type
	zoom_bar.hide()
	if document.special_font:
		content.remove_theme_font_override("mono_font")
		content.add_theme_font_override("mono_font", load(document.special_font.resource_path))
	
	process_document(document)
	document_texture.texture = load(document.texture.resource_path)
	document_texture.size = Vector2(1680, 1080)
	document_texture.position = Vector2(-840, -540)
	document_texture.pivot_offset = Vector2(840, 540)
	doc_title.set_text(document.name.to_upper())
	zoom_bar.value = 0
	zoom_slider.value = 0
	doc.position = get_viewport_rect().get_center()
	doc.scale = DEFAULT_SCALE # zoom level 0%
	animator.play("unblurred")
	


func read(page_number: int) -> void:
	assert(page_number in range(0, page_count + 1))
	current_page = page_number
	doc_page.set_text("%d/%d" % [current_page, page_count])
	var text = pages.get(current_page)
	if text:
		content.set_text(text)


## =================================================================================================


func process_document(document: File) -> void:
	match MODE:
		"Multi":
			paginate_text(document)
		"Single":
			paginate_text(document) if PAGE_SEP in document.text else load_single(document)
		"Scroll":
			paginate_text(document)
		_:
			pass


func load_single(document: File) -> void:
	pages[0] = ""
	if document.text.length() > 0:
		if show_hints:
			if has_hints(document.text):
				var hint_text = get_hints_from_text(document.text)
				pages[pages.size()] = hint_text
				page_count += 1
		else:
			if has_hints(document.text):
				var processed = document.text.replace(HINT_SEP, "") as String
				pages[pages.size()] = processed
				page_count += 1
			else:
				pages[pages.size()] = document.text
				page_count += 1



func merge_pages(text: String) -> void:
	pass




func paginate_text(document: File) -> void:
	pages[0] = ""
	var lines = document.text.split(PAGE_SEP)
	for p in lines:
		if show_hints:
			if has_hints(p):
				var hint_text = get_hints_from_text(p)
				pages[pages.size()] = hint_text
				page_count += 1
			else:
				pages[pages.size()] = p
				page_count += 1
			
		elif not show_hints:
			if has_hints(p):
				var processed = p.replace(HINT_SEP, "") as String
				pages[pages.size()] = processed
				page_count += 1
			else:
				pages[pages.size()] = p
				page_count += 1





func has_hints(text: String) -> bool:
	return true if text.contains(HINT_SEP) else false


func format_hint_text(text: String) -> String:
	return "[color=green][outline_color=green][outline_size=2][b]%s[/b][/outline_size][/outline_color][/color]" % text


func get_hints_from_text(text: String) -> String:
	var split_text = text.split(HINT_SEP)
	var formatted_text = split_text.duplicate()
	
	for i in range(1, split_text.size(), 2):
		# apply the hint formatting to each hint, then replace the original text with that
		formatted_text.set(i, format_hint_text(split_text[i]))
	return "".join(formatted_text)


## =================================================================================================

func has_next(page_number: int) -> bool:
	return true if page_number + 1 <= page_count else false

func has_previous(page_number: int) -> bool:
	return true if page_number - 1 >= 0 else false




## =================================================================================================

func _on_examine_toggled(toggled_on: bool) -> void:
	ploot.play()
	
	if toggled_on:
		animator.play("unblurred")
		navigation_buttons.hide()
		doc_page.hide()
		blurred = false
		doc_title.add_theme_color_override("font_color", Color("#155611"))
		examine.modulate = Color("#155611")
		content.hide()
		zoom_bar.show()
	else:
		examine.modulate = Color("#3cf231")
		doc_title.add_theme_color_override("font_color", Color("#3cf231"))
		animator.play("blur")
		blurred = true
		doc_page.show()
		navigation_buttons.show()
		content.show()
		zoom_bar.hide()



func _on_closed() -> void:
	pages.clear()
	current_page = 0
	page_count = 0
	setup_complete = false
	current_document = null
	#current_map = null
	animator.play("unblurred")
	blurred = false
	doc_page.text = ""
	content.text = ""
	content.hide()
	navigation_buttons.show()
	close.show()
	r.show()
	l.hide()
	zoom_bar.value = 0
	doc.scale = DEFAULT_SCALE
	hide()




func _on_close_pressed() -> void:
	boodoowoop_reversed.play()
	closed.emit()
	hide()


func _on_opened() -> void:
	boodoowoop.play()
	

func _on_l_pressed() -> void:
	if has_previous(current_page):
		page_flip.play()
		current_page -= 1
		if current_page == 0:
			animator.play("unblurred")
			doc_page.hide()
			l.hide()
			r.show()
			close.show()
			content.hide()
		else:
			read(current_page)
			close.hide()
			r.show()
			l.show()
		


func _on_r_pressed() -> void:
	if has_next(current_page):
		page_flip.play()
		current_page += 1
		if current_page == 1:
			animator.play("blur")
			doc_page.show()
			content.show()
			l.show()
			r.show()
			close.hide()
		if current_page == page_count:
			close.show()
			r.hide()
			l.show()
		
		
		read(current_page)


func _on_zoom_changed(value: float) -> void:
	if current_document:
		var t = value / 100
		zoom_slider.value = value
		zoom_bar.value = zoom_slider.value
		doc.scale = DEFAULT_SCALE.lerp(2 * DEFAULT_SCALE, t)


func _on_document_drag_begin() -> void:
	dragging = true
	offset_ = document_texture.get_global_mouse_position() - document_texture.global_position


func _on_document_drag_ended() -> void:
	dragging = false
