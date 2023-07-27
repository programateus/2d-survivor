extends CanvasLayer

@export var arena_time_manager: ArenaTimeManager

@onready var label = $MarginContainer/Label

func _process(delta: float):
	label.text = format_seconds(arena_time_manager.get_time_elapsed())

func format_seconds(seconds: float):
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	return str(minutes) + ":" + "%02d" % floor(remaining_seconds)
