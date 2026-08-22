extends Node2D

enum BattleState { INTRO, PLAYER_TURN, MINIGAME, ENEMY_TURN, RESOLVE, VICTORY, DEFEAT }

var current_state: BattleState = BattleState.INTRO
@export var rhinovirus: UnitStats
@export var influenza: UnitStats
@export var bacteriophage: UnitStats
@export var pick: PackedScene
@export var study: PackedScene
@export var blueprint: PackedScene
@export var mini_1_scene: PackedScene
@export var mini_2_scene: PackedScene
@export var mini_3_scene: PackedScene
@export var mini_4_scene: PackedScene
var game = null
var attacker = null
var menu = null
var last_attack = ""
var adaptation_mult = 1.0
var charges = 3
var animation = null
var wave = 0
var wave_enemies = ["RhinoVirus", "Influenza", "Bacteriophage"]
var unlocked = ["RhinoVirus"]
var type_chart = {
	"Antibody": {
		"Replication": 1.5,
		"Mutation": 0.5,
		"Injection": 1.0,
	},
	"Fever": {
		"Replication": 1.5,
		"Mutation": 1.0,
		"Injection": 0.5,
	},
	"Phagocytosis": {
		"Replication": 0.5,
		"Mutation": 1.0,
		"Injection": 1.5,
	},
	"Interferon": {
		"Replication": 1.5,
		"Mutation": 0.5,
		"Injection": 1.0,
	},
}
func _ready():
	change_state(BattleState.INTRO)
	$"I-Beam".visible = false
	$Fire.visible = false
	$Munch.visible = false
	$Bulls_Eye.visible = false
	$Win.visible = false
	$Lose.visible = false
	$Wave.visible = false
	menu = pick.instantiate()
	add_child(menu)
	menu.visible = false
	$Menu_Button.visible = false
	menu.process_mode = Node.PROCESS_MODE_INHERIT
	menu.attack_picked.connect(_on_attack_picked)
	$Menu_Button.pressed.connect(_on_button_pressed)
	$Player.attack_finished.connect(_on_attack_finished)
	$Enemy.attack_finished.connect(_on_attack_finished)
	$Player/Charges.value = 3

func change_state(new_state: BattleState):
	current_state = new_state
	match current_state:
		BattleState.INTRO:
			print("Battle starting...")
			$Fight_Timer.start()
		BattleState.PLAYER_TURN:
			print("Player's turn!")
			attacker = "player"
			menu.visible = true
			menu.process_mode = Node.PROCESS_MODE_INHERIT
		BattleState.MINIGAME:
			menu.visible = false
			menu.process_mode = Node.PROCESS_MODE_DISABLED
			print("Minigame rn")
		BattleState.ENEMY_TURN:
			attacker = "enemy"
			print("Enemy's turn!")
			$Enemy.perform_attack($Player)
		BattleState.RESOLVE:
			print("Resolving turn...")
			if attacker == "player" and $Enemy.stats.current_hp == 0:
				change_state(BattleState.VICTORY)
			elif attacker == "enemy" and $Player.stats.current_hp == 0:
				change_state(BattleState.DEFEAT)
			elif attacker == "player":
				change_state(BattleState.ENEMY_TURN)
			else:
				change_state(BattleState.PLAYER_TURN)
		BattleState.VICTORY:
			if wave == wave_enemies.size() - 1:
				$Win.visible = true
				$Menu_Button.visible = true
				await get_tree().create_timer(1.2).timeout
				$Win.visible = false
				print("You win!")
			else:
				next_wave()
		BattleState.DEFEAT:
			$Lose.visible = true
			$Menu_Button.visible = true
			await get_tree().create_timer(1.2).timeout
			$Lose.visible = false
			print("You lose...")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass 


func _on_fight_timer_timeout():
	change_state(BattleState.PLAYER_TURN)
	
func _on_attack_picked(attack_name):
	if attack_name == last_attack:
		adaptation_mult = 0.75
	else:
		adaptation_mult = 1.0
		last_attack = attack_name
	if attack_name == "Analyze":
		game = study.instantiate()
		add_child(game)
		game.analyze_done.connect(_on_analyze_done)
	elif attack_name == "Inspect":
		game = blueprint.instantiate()
		add_child(game)
		game.open(unlocked)
		game.x_pressed.connect(_on_x_pressed)

	elif charges >= 1:
		charges -= 1
		$Player/Charges.value -= 1
		match attack_name:
			"Fever":
				game = mini_1_scene.instantiate()
				animation = $Fire
			"Antibody":
				game = mini_2_scene.instantiate()
				animation = $Bulls_Eye
			"Phagocytosis":
				game = mini_3_scene.instantiate()
				animation = $Munch
			"Interferon":
				game = mini_4_scene.instantiate()
				animation = $"I-Beam"
				
		add_child(game)
		game.minigame_complete.connect(_on_minigame_complete)
	change_state(BattleState.MINIGAME)
	menu.update_charges(charges)

func _on_attack_finished():
	change_state(BattleState.RESOLVE)
func _on_minigame_complete(mult):
	if last_attack == "Fever":
		$Player/AnimationPlayer.play("fever_up")
	animation.visible = true
	animation.play("1")
	$Animation.start()
	$Enemy.stats.take_damage($Player.stats.attack_power * mult * adaptation_mult * type_chart[$Player.stats.unit_type][$Enemy.stats.unit_type])
	game.queue_free()

func _on_analyze_done(correct):
	if correct:
		charges += 1
		$Player/Charges.value += 1
	else:
		charges += 0.5
		$Player/Charges.value += 0.5
	game.queue_free()
	menu.update_charges(charges)
	change_state(BattleState.RESOLVE)
	
func next_wave():
	wave += 1
	$Enemy.stats.hp_changed.disconnect($Enemy._on_hp_changed)
	match wave_enemies[wave]:
		"Influenza":
			$Enemy.stats = influenza
			$Enemy/Enemy_Sprite.texture = load("res://assets/Influenza.png")
		"Bacteriophage":
			$Enemy.stats = bacteriophage
			$Enemy/Enemy_Sprite.texture = load("res://assets/Bacteriophage.png")
	$Enemy.stats.hp_changed.connect($Enemy._on_hp_changed)
	$Enemy.stats.current_hp = $Enemy.stats.max_hp
	$Enemy/HealthBar.max_value = $Enemy.stats.max_hp
	$Enemy/HealthBar.value = $Enemy.stats.current_hp
	$Wave.visible = true
	$Player/Charges.value +=1
	charges += 1
	menu.update_charges(charges)
	await get_tree().create_timer(0.8).timeout
	$Wave.visible = false
	unlocked.append(wave_enemies[wave])
	change_state(BattleState.PLAYER_TURN)
func _on_animation_timeout():
	animation.visible = false
	animation.stop()
	change_state(BattleState.RESOLVE) 
func _on_button_pressed():
	get_tree().change_scene_to_file("res://game_menu.tscn")
func _on_x_pressed():
	change_state(BattleState.PLAYER_TURN)
