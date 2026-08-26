extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.pressed.connect(_on_button_pressed)
	$ColorRect.modulate = Color(1, 1, 1, 0)
	$ColorRect.visible = false
	$AudioStreamPlayer.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func _on_button_pressed():
	$ColorRect.visible = true
	var tween = create_tween()
	tween.tween_property($ColorRect,"modulate:a", 1.0, 1.0)
	await tween.finished
	get_tree().change_scene_to_file("res://battle.tscn")
