extends CanvasLayer
signal attack_picked(attack_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Analyze.attack_option.connect(_on_attack_option)
	$Inspect.attack_option.connect(_on_attack_option)
	$Antibody.attack_option.connect(_on_attack_option)
	$Fever.attack_option.connect(_on_attack_option)
	$Interferon.attack_option.connect(_on_attack_option)
	$Phagocytosis.attack_option.connect(_on_attack_option)
	$Analyze.modulate = Color(1, 1, 1, 0.4)
	$Analyze.process_mode = Node.PROCESS_MODE_DISABLED
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func _on_attack_option(attack_name):
	attack_picked.emit(attack_name)
func update_charges(charges):
	$Analyze.modulate = Color(1, 1, 1, 1)
	$Analyze.process_mode = Node.PROCESS_MODE_INHERIT
	if charges < 1:
		$Antibody.modulate = Color(1, 1, 1, 0.4)
		$Antibody.process_mode = Node.PROCESS_MODE_DISABLED
		$Fever.modulate = Color(1, 1, 1, 0.4)
		$Fever.process_mode = Node.PROCESS_MODE_DISABLED
		$Interferon.modulate = Color(1, 1, 1, 0.4)
		$Interferon.process_mode = Node.PROCESS_MODE_DISABLED
		$Phagocytosis.modulate = Color(1, 1, 1, 0.4)
		$Phagocytosis.process_mode = Node.PROCESS_MODE_DISABLED
	elif charges >= 1 and charges <= 2:
		$Antibody.modulate = Color(1, 1, 1, 1)
		$Antibody.process_mode = Node.PROCESS_MODE_INHERIT
		$Fever.modulate = Color(1, 1, 1, 1)
		$Fever.process_mode = Node.PROCESS_MODE_INHERIT
		$Interferon.modulate = Color(1, 1, 1, 1)
		$Interferon.process_mode = Node.PROCESS_MODE_INHERIT
		$Phagocytosis.modulate = Color(1, 1, 1, 1)
		$Phagocytosis.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		$Analyze.modulate = Color(1, 1, 1, 0.4)
		$Analyze.process_mode = Node.PROCESS_MODE_DISABLED
