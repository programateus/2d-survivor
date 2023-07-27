extends Node

const SPAWN_RADIUS = 360

@export var arena_time_manager: ArenaTimeManager
@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene

@onready var timer = $Timer

var enemies_table = WeightedTable.new()
var base_spawn_time = 0

func _ready():
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	timer.timeout.connect(on_timer_timeout)
	base_spawn_time = timer.wait_time
	enemies_table.add_item(basic_enemy_scene, 10)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = player.global_position + random_direction * SPAWN_RADIUS
		var additional_check_offset = random_direction * 20
		
		var ray = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(ray)
		if result.is_empty():
			return spawn_position
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func on_timer_timeout():
	timer.start()
	var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		return
	
	var enemy_scene = enemies_table.pick_item()
	var enemy = enemy_scene.instantiate()
	get_tree().get_first_node_in_group("entities_layer").get_parent().add_child(enemy)
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(difficulty: int):
	var time_off = (0.1 / 12) * difficulty
	time_off = min(time_off, .4)
	timer.wait_time = base_spawn_time - time_off
	
	if (difficulty == 6):
		enemies_table.add_item(wizard_enemy_scene, 20)
