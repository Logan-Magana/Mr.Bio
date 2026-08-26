extends Resource
class_name UnitStats

@export var unit_name: String = ""
@export var max_hp: int = 100
@export var current_hp: int = 100
@export var attack_power: int = 10
@export var unit_type: String = ""

signal hp_changed(new_hp, max_hp)

func take_damage(amount: int):
	current_hp -= amount
	current_hp = clamp(current_hp, 0, max_hp)
	hp_changed.emit(current_hp, max_hp)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
