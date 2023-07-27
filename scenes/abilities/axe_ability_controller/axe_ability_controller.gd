extends Node
class_name AxeAbilityController

@export var damage = 5
@export var axe_ability_scene: PackedScene

@onready var timer = $Timer

var additional_damage_percent = 1.0

func _ready():
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	if foreground == null:
		return
	
	var axe_ability = axe_ability_scene.instantiate() as AxeAbility
	foreground.add_child(axe_ability)
	axe_ability.global_position = player.global_position
	axe_ability.hitbox_component.damage = damage * additional_damage_percent


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage_percent = 1 + (current_upgrades["axe_damage"]["quantity"] * .1)
