extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent
@export var floating_text_scene: PackedScene

func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D):
	if not area is HitboxComponent:
		return
	
	var hitbox_component: HitboxComponent = area as HitboxComponent
	health_component.damage(hitbox_component.damage)
	
	hit.emit()
	var floating_text = floating_text_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = global_position + (Vector2.UP * 16)
	floating_text.start(str(hitbox_component.damage))
