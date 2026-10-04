extends Node2D
signal analyze_done(correct)
var player_answer = null
var player_val = null
var correct_val = null
var file = FileAccess.open(GameData.question_file, FileAccess.READ)
var json_string = file.get_as_text()
var questions = JSON.parse_string(json_string)
var current_question = questions[randi() % questions.size()]
@onready var buttons = [$"Choice-A", $"Choice-B", $"Choice-C",$"Choice-D"]
# Called when the node enters the scene tree for the first time.
func _ready():
	$Typing/Submit.pressed.connect(_on_submit_pressed)
	$Question.text = current_question["question"]
	if current_question["type"] == "mc":
		$Typing.visible = false
		$"Choice-A".pressed.connect(_on_button_pressed.bind(0))
		$"Choice-B".pressed.connect(_on_button_pressed.bind(1))
		$"Choice-C".pressed.connect(_on_button_pressed.bind(2))
		$"Choice-D".pressed.connect(_on_button_pressed.bind(3))
		$"Choice-A".visible = true
		$"Choice-B".visible = true
		$"Choice-C".visible = true
		$"Choice-D".visible = true
		$"Choice-A".text = current_question["answers"][0]
		$"Choice-B".text = current_question["answers"][1]
		$"Choice-C".text = current_question["answers"][2]
		$"Choice-D".text = current_question["answers"][3]
	else:
		$"Choice-A".visible = false
		$"Choice-B".visible = false
		$"Choice-C".visible = false
		$"Choice-D".visible = false
		$Typing.visible = true
		
		
		
	if current_question.has("image"):
		$Image.texture = load(current_question["image"])
		$Image.visible = true
	else:
		$Image.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func _on_submit_pressed():
	player_answer = $Typing.text.strip_edges()
	print(current_question["correct"])
	print(typeof(current_question["correct"]))
	correct_val = float(current_question["correct"])
	player_val = float(player_answer)
	var correct = abs(player_val - correct_val) < 0.05
	if correct:
		$Typing/Submit.modulate =  Color(0, 1, 0, 1)
	else:
		$Typing/Submit.modulate =  Color(1, 0, 0, 1)
	await get_tree().create_timer(0.8).timeout
	analyze_done.emit(correct)
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
