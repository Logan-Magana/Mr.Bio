extends CanvasLayer
signal x_pressed
var enemy_data = {
	"RhinoVirus": {
		"description": "A common cold virus that uses its replication to its advantage. Weakens in high temperature"
	},
	"Influenza": {
		"description": "The Flu virus. Prone to mutating, making it hard to pin down with antibodies"
	},
	"Bacteriophage": {
		"description": "A virus that only attacks bacteria. Its small body can easily be taken care of by the hungry Macrophages"
	},
}
var page = 0
var unlocked_enemies = null
var enemy_name = null
var data = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Prev_Button.pressed.connect(_on_prev_button_pressed)
	$Next_Button.pressed.connect(_on_next_button_pressed)
	$X_Button.pressed.connect(_on_x_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_prev_button_pressed():
	page = max(page - 1, 0)
	update_page()
func _on_next_button_pressed():
	page = min(page + 1, unlocked_enemies.size() - 1)
	update_page()
func _on_x_button_pressed():
	queue_free()
	x_pressed.emit()
	
func open(unlocked):
	unlocked_enemies = unlocked
	update_page()
	
func update_page():
	enemy_name =  unlocked_enemies[page]
	data = enemy_data[enemy_name]
	$Enemy_Sprite.texture = load("res://assets/" + enemy_name + ".png")
	$Enemy_Name.text = enemy_name
	$Description.text = data["description"]
