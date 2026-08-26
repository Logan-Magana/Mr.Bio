extends Node2D
signal minigame_complete()
var threshold = 15
@export var cells: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Controls.visible = true
	$Controls_Sprite.visible = true
	await get_tree().create_timer(1.4).timeout
	$Controls.visible = false
	$Controls_Sprite.visible = false
	$Infected/GameTimer.start()
	$Infected.cell_signaled.connect(spawn_cell)
	for i in range(9):
		spawn_cell()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

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
