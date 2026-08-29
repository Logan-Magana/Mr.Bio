extends Node2D
signal analyze_done(correct)
var file = FileAccess.open(GameData.question_file, FileAccess.READ)
var json_string = file.get_as_text()
var questions = JSON.parse_string(json_string)
var current_question = questions[randi() % questions.size()]
@onready var buttons = [$"Choice-A", $"Choice-B", $"Choice-C",$"Choice-D"]
# Called when the node enters the scene tree for the first time.
func _ready():
	$"Choice-A".pressed.connect(_on_button_pressed.bind(0))
	$"Choice-B".pressed.connect(_on_button_pressed.bind(1))
	$"Choice-C".pressed.connect(_on_button_pressed.bind(2))
	$"Choice-D".pressed.connect(_on_button_pressed.bind(3))
	$Label.text = current_question["question"]
	$"Choice-A".text = current_question["answers"][0]
	$"Choice-B".text = current_question["answers"][1]
	$"Choice-C".text = current_question["answers"][2]
	$"Choice-D".text = current_question["answers"][3]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func _on_button_pressed(answer):
	var correct = answer == current_question["correct"]
	if correct:
		buttons[answer].modulate = Color(0, 1, 0, 1)
	else:
		buttons[answer].modulate = Color(1, 0, 0, 1)
	await get_tree().create_timer(0.8).timeout
	buttons[answer].modulate = Color(1, 1, 1, 1)
	analyze_done.emit(correct)
	print(correct)
