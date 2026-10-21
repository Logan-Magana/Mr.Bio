extends Node2D
@export var character:PackedScene
var scene = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Bio.pressed.connect(_on_bio_button_pressed)
	$Chem.pressed.connect(_on_chem_button_pressed)
	$Espanol.pressed.connect(_on_espa_button_pressed)
	$Mix.pressed.connect(_on_mix_pressed)
	$Present.pressed.connect(_on_pres_pressed)
	$Bio.visible = false
	$Espanol.visible = false
	
	$Chem.visible = false
	#$Bio.process_mode = Node.PROCESS_MODE_DISABLED
	$Espanol.process_mode = Node.PROCESS_MODE_DISABLED
	$Chem.process_mode = Node.PROCESS_MODE_DISABLED
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func start_up():
	$CanvasLayer/ColorRect.visible = true
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect,"modulate:a", 1.0, 1.0)
	await tween.finished
	get_tree().change_scene_to_file("res://battle.tscn")

#func _on_bio_button_pressed():
#	GameData.question_file = "res://questions.json"
#	start_up()
func _on_espa_button_pressed():
	extra_menu()
func _on_chem_button_pressed():
	GameData.question_file = "res://fall_midterm_chem.json"
	start_up()

func _on_canvas_layer_question_select() -> void:
	scene = character.instantiate()
	add_child(scene)
	scene.next_menu.connect(_on_next_menu)
	
func _on_next_menu():
	scene.queue_free()
	#$Bio.visible = true
	$Espanol.visible = true
	$Chem.visible = true
	#$Bio.process_mode = Node.PROCESS_MODE_INHERIT
	$Espanol.process_mode = Node.PROCESS_MODE_INHERIT
	$Chem.process_mode = Node.PROCESS_MODE_INHERIT
	$CanvasLayer/Button.visible = false
	$CanvasLayer/Button.process_mode = Node.PROCESS_MODE_DISABLED
	
func extra_menu():
	$Mix.visible = true
	$Present.visible = true
	$Espanol.visible = false
	$Chem.visible = false
	#$Bio.process_mode = Node.PROCESS_MODE_DISABLED
	$Espanol.process_mode = Node.PROCESS_MODE_DISABLED
	$Chem.process_mode = Node.PROCESS_MODE_DISABLED
	
func _on_mix_pressed():
	GameData.question_file = "res://spanish_tenses_mix.json"
	start_up()
	
func _on_pres_pressed():
	GameData.question_file ="res://spanish_tenses_present.json"
	start_up()
