extends CharacterBody2D
class_name Player

const ACCELERATION_SMOOTHING = 50

@onready var health_component = $HealthComponent
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var velocity_component = $VelocityComponent

var colliding_bodies: Array[Node2D]
var base_speed = 0

func _ready():
	$CollisionArea.body_entered.connect(on_body_entered)
	$CollisionArea.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	base_speed = velocity_component.max_speed


func _physics_process(delta: float):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x < 0:
		$Visuals.scale.x = -1
	if movement_vector.x > 1:
		$Visuals.scale.x = 1
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")


func get_movement_vector() -> Vector2:
	var movement_vector = Vector2.ZERO
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	movement_vector.x = x_movement
	movement_vector.y = y_movement
	return movement_vector


func take_damage():
	if colliding_bodies.size() == 0 || !damage_interval_timer.is_stopped():
		return
	$RandomAudioPlayerComponent.play_random()
	health_component.damage(1)
	GameEvents.emit_player_damaged()
	damage_interval_timer.start()


func on_damage_interval_timer_timeout():
	take_damage()


func on_body_entered(body: Node2D):
	colliding_bodies.append(body)
	take_damage()


func on_body_exited(body: Node2D):
	colliding_bodies.erase(body)


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade is Ability:
		abilities.add_child(upgrade.ability_controller_scene.instantiate())
	elif upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .08)
