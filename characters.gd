extends CanvasLayer
signal next_menu()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"T-Cell".char_picked.connect(_on_char_picked)
	$"B-Cell".char_picked.connect(_on_char_picked)
	$Macrophage.char_picked.connect(_on_char_picked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_char_picked(char):
	GameData.player = char
	next_menu.emit()
