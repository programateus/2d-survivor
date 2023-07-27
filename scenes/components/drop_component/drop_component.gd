extends Node

@export_range(0, 1) var drop_percent: float = 0.5;
@export var drop_scenes: Array[PackedScene]
@export var health_component: HealthComponent

func _ready():
	health_component.died.connect(on_died)

func on_died():
	if randf() > drop_percent:
		return
	for scene in drop_scenes:
		var drop = scene.instantiate()
		var spawn_position = owner.global_position
		owner.get_parent().add_child(drop)
		drop.global_position = spawn_position
