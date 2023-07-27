extends Node2D
class_name AxeAbility

const MAX_RADIUS = 200

@onready var hitbox_component = $HitboxComponent

var base_rotation = Vector2.RIGHT

func _ready():
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	tween.finished.connect(on_tween_finished)
	tween.tween_method(tween_method, 0.0, 1.3, 2)


func tween_method(rotations: float):
	var percent = rotations / 2
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	global_position = player.global_position + (current_direction * current_radius)


func on_tween_finished():
	queue_free()
