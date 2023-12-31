extends Node
class_name ArenaTimeManager

signal arena_difficulty_increased(difficulty: int)

const DIFFICULTY_INTERVAL = 5

@export var end_screen_scene: PackedScene

@onready var timer = $Timer

var arena_difficulty = 0


func _ready():
	timer.timeout.connect(on_arena_timer_timeout)


func _process(delta):
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_arena_timer_timeout():
	var end_screen = end_screen_scene.instantiate() as EndScreen
	get_tree().root.add_child(end_screen)
	end_screen.set_victory()
