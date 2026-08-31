extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bio.pressed.connect(_on_bio_button_pressed)
	$Geometry.pressed.connect(_on_geo_button_pressed)
	$Chem.pressed.connect(_on_chem_button_pressed)
	$Bio.visible = false
	$Geometry.visible = false
	$Chem.visible = false
	$Bio.process_mode = Node.PROCESS_MODE_DISABLED
	$Geometry.process_mode = Node.PROCESS_MODE_DISABLED
	$Chem.process_mode = Node.PROCESS_MODE_DISABLED
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func start_up():
	$CanvasLayer/ColorRect.visible = true
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect,"modulate:a", 1.0, 1.0)
	await tween.finished
	get_tree().change_scene_to_file("res://battle.tscn")

func _on_bio_button_pressed():
	GameData.question_file = "res://questions.json"
	start_up()
func _on_geo_button_pressed():
	GameData.question_file = "res://geometry_q.json"
	start_up()
func _on_chem_button_pressed():
	GameData.question_file = "res://chem.json"
	start_up()

func _on_canvas_layer_question_select() -> void:
	$Bio.visible = true
	$Geometry.visible = true
	$Chem.visible = true
	$Bio.process_mode = Node.PROCESS_MODE_INHERIT
	$Geometry.process_mode = Node.PROCESS_MODE_INHERIT
	$Chem.process_mode = Node.PROCESS_MODE_INHERIT
	$CanvasLayer/Button.visible = false
	$CanvasLayer/Button.process_mode = Node.PROCESS_MODE_DISABLED
