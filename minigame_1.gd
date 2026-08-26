extends Node2D

signal minigame_complete()
@onready var heat_meter = $Heat_Meter
var animation_length = 1.0
var threshold = 90
func _ready() -> void:
	$Player/AnimationPlayer.assigned_animation = "fever_charge_up"
	heat_meter.value = 0
	$Controls.visible = true
	$Controls_Sprite.visible = true
	await get_tree().create_timer(1.4).timeout
	$Controls.visible = false
	$Controls_Sprite.visible = false
	$Timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Fever_Game") and $Timer.time_left > 0:
		heat_meter.value += 2
	var meter_ratio = heat_meter.value / heat_meter.max_value
	$Player/AnimationPlayer.seek( meter_ratio * animation_length, true)

func _on_timer_timeout() -> void:
	if heat_meter.value >= threshold:
		minigame_complete.emit(1.0)
		print(1.0)
	else:
		minigame_complete.emit(0.5)	
		print(0.5)
