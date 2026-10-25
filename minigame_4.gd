extends Node2D
signal minigame_complete()
var threshold = 30
var control_on = false
@export var cells: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Controls.visible = true
	$Controls_Sprite.visible = true
	$Infected.cell_signaled.connect(spawn_cell)
	await get_tree().create_timer(0.5).timeout
	control_on = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if control_on and Input.is_anything_pressed():
		$Controls.visible = false
		$Controls_Sprite.visible = false
		control_on = false
		$Infected/GameTimer.start()
		$Infected/CellTimer.start()
		$Infected/AnimationPlayer.play("infected")
		for i in range(9):
			spawn_cell()
func spawn_cell():
	if $Infected/GameTimer.time_left > 0:
		var cell = cells.instantiate()
		add_child(cell)

func _on_game_timer_timeout():
	if $Infected.points >= threshold:
		minigame_complete.emit(1.0)
		print(1.0)
	else:
		minigame_complete.emit(0.5)
		print(0.5)
