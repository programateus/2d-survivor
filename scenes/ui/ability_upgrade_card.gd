extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label = %Name
@onready var description_label = %Description
@onready var button = %ChoseButton

func _ready():
	button.pressed.connect(on_button_pressed)


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func on_button_pressed():
	selected.emit()
