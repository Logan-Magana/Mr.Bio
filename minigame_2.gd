extends Node2D
@export var targets: PackedScene
@onready var sfx = $SFX
var sound = [preload("res://assets/fake_laser.wav"), preload("res://assets/real_laser.wav")]
signal minigame_complete()
var score = 0
var threshold = 35
# Called when the node enters the scene tree for the first time.
func _ready():
	$Controls.visible = true
	$Controls_Sprite.visible = true
	$Controls_Sprite2.visible = true
	await get_tree().create_timer(1.4).timeout
	$Controls.visible = false
	$Controls_Sprite.visible = false
	$Controls_Sprite2.visible = false
	$Timer.start()
	for i in range(9):
		spawn_target()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_target():
	if $Timer.time_left > 0:
		var tar = targets.instantiate()
		tar.is_real = randf() > 0.5
		add_child(tar)
		tar.position = Vector2(randf_range(50,430), randf_range(50,220))
		tar.target_clicked.connect(_on_target_clicked.bind(tar))
		tar.target_timeout.connect(_on_target_timeout)
func _on_target_clicked( is_real, tar):
	if is_real == true:
		score += 5
		sfx.stream = sound[1]
		sfx.play()
	else:
		score -= 3
		sfx.stream = sound[0]
		sfx.play()
	tar.queue_free()
	spawn_target()

func _on_target_timeout():
	spawn_target()

func _on_timer_timeout():
	if score >= threshold:
		minigame_complete.emit(1.0)
		print(1.0)
	else:
		minigame_complete.emit(0.5)
		print(0.5)
