class_name TypewriterLabel extends Label

@onready var timer: Timer = $Timer
@onready var tick: AudioStreamPlayer = $Tick

var text_to_type: String = "HERE IS SOME TEXT TO BE TYPED OUT"
var words: PackedStringArray
var space_positions: PackedInt32Array

var offset_position: int = 0
var cur_word: int = 0

var stored_text: String = ""


signal type_text(new_text: String)


#func _ready() -> void:
	#type_text.connect(type_out)


func type_out(new_text: String) -> void:
	print("typing '%s'" % new_text)
	hide()
	words = new_text.split(" ", false)
	space_positions = PackedInt32Array()
	# Checking that the desired length is being padded
	for i in range(text.length()):
		if text.substr(i, 1) == " ":
			space_positions.append(i)
	timer.start()
	show()

func fill_word(word: String, position: int) -> String:
		var output: String = word.substr(0, position)
		var space_len = word.length() - position
		
		for i in range(space_len):
			output += " "
		return output



func _on_timer_timeout() -> void:
	offset_position += 1
	var filled = fill_word(words[cur_word], offset_position)
	text = stored_text + fill_word(words[cur_word], offset_position)
	# Checking to see if the word was being padded correctly
	if offset_position == words[cur_word].length():
		stored_text += words[cur_word] # Add the current word to stored text
		
		cur_word += 1
		offset_position = 0 # Reset to the start of the next word
		tick.play()
		
		
		# Add a space between words if there are more words incoming.
		if cur_word < words.size():
			stored_text += " "
	
	if cur_word == words.size():
		timer.stop()
		hide()
