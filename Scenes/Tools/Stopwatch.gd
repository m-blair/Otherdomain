class_name Stopwatch
extends Node


@export var time = 0.0
@export var stopped: bool = true


@export var splits: Dictionary = {}
var max_split_count := 5

signal split


func _process(delta: float) -> void:
	if not stopped:
		time += delta
		
		
		
	else:
		return



func _reset() -> void:
	time = 0.0


func _on_split() -> void:
	splits[splits.size() % max_split_count] = time


func time_to_string() -> String:
	var msecs = fmod(time, 1) * 1000
	var secs = fmod(time, 60)
	var mins = time / 60
	var format_str = "%02d : %02d : %02d"
	var formatted = format_str % [mins, secs, msecs]
	return formatted
	
