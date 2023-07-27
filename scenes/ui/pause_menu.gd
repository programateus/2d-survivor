extends CanvasLayer
class_name PauseMenu

var options_scene = preload("res://scenes/ui/options_menu.tscn")

@onready var resume_button = %ResumeButton
@onready var options_button = %OptionsButton
@onready var quit_button = %QuitButton


func _ready():
	get_tree().paused = true
	resume_button.pressed.connect(on_resume_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)


func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		get_tree().root.set_input_as_handled()
		get_tree().paused = false
		queue_free()


func on_resume_pressed():
	get_tree().paused = false
	queue_free()


func on_options_pressed():
	var options = options_scene.instantiate()
	add_child(options)
	options.get_node("TileMap").visible = false
	options.back_pressed.connect(on_options_closed.bind(options))


func on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func on_options_closed(options: Node):
	options.queue_free()
