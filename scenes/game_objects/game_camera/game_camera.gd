extends Camera2D
class_name GameCamera

var target_position = Vector2.ZERO


func _ready():
	make_current()


func _physics_process(delta: float):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	target_position = player.global_position
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))
