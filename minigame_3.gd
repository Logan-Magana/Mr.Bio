extends Node2D
signal minigame_complete()
var threshold = 20
func _ready():
	$Controls.visible = true
	$Controls_Sprite.visible = true
	await get_tree().create_timer(1.4).timeout
	$Controls.visible = false
	$Controls_Sprite.visible = false


func _on_timer_timeout():
	if $Macrophage.meter >= threshold:
		minigame_complete.emit(1.0)
	else:
		minigame_complete.emit(0.5)
