extends Node
class_name Main

@export var end_screen_scene: PackedScene
@export var pause_screen_scene: PackedScene

func _ready():
	%Player.health_component.died.connect(on_player_died)


func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		var pause_screen = pause_screen_scene.instantiate()
		add_child(pause_screen)
		get_tree().root.set_input_as_handled()


func on_player_died():
	var end_screen = end_screen_scene.instantiate() as EndScreen
	get_tree().root.add_child(end_screen)
	end_screen.set_defeat()
