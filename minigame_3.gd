extends Node2D
signal minigame_complete()
var threshold = 2.5
var control_on = false
func _ready():
	$Controls.visible = true
	$Controls_Sprite.visible = true
	await get_tree().create_timer(0.5).timeout
	control_on = true
func _process(delta: float) -> void:
	if control_on and Input.is_anything_pressed():
		$Controls.visible = false
		$Controls_Sprite.visible = false
		control_on = false
		$Macrophage/Timer.start()
func _on_timer_timeout():
	if $Macrophage.meter >= threshold:
		minigame_complete.emit(1.0)
	else:
		minigame_complete.emit(0.5)
	print($Macrophage.meter)
