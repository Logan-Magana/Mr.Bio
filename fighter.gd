extends Area2D
@export var stats: UnitStats
signal attack_finished
var current_target = null
@onready var animation_player = $AnimationPlayer
@onready var health_bar = $HealthBar


# Called when the node enters the scene tree for the first time.
func _ready():
	stats.hp_changed.connect(_on_hp_changed)
	health_bar.max_value = stats.max_hp
	health_bar.value = stats.current_hp
func _on_hp_changed(new_hp, max_hp):
		health_bar.value = new_hp
		health_bar.max_value = max_hp
func perform_attack(target):
	current_target = target
	animation_player.play("lunge_attack")
	current_target.stats.take_damage(stats.attack_power)
	attack_finished.emit()
