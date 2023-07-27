extends Node2D
class_name DeathComponent

@export var health_component: HealthComponent
@export var sprite: Sprite2D

func _ready():
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)


func on_died():
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if owner == null:
		return
	var spawn_position = owner.global_position
	$RandomAudioPlayerComponent.play_random()
	get_parent().remove_child(self)
	entities_layer.add_child(self)
	global_position = spawn_position
	$AnimationPlayer.play("default")
