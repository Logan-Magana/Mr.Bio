extends Area2D
var screen_size
var is_touching = false
var points = 1
var meter = 0
@export var speed = 400
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_touching and $Timer.time_left > 0:
		meter += points * delta
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("Move_Left"):
		velocity.x -= 1
	if Input.is_action_pressed("Move_Right"):
		velocity.x += 1
	if Input.is_action_pressed("Move_Down"):
		velocity.y += 1
	if Input.is_action_pressed("Move_Up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_bacteriophage_area_entered(_area: Area2D):
	is_touching = true


func _on_bacteriophage_area_exited(_area: Area2D):
	is_touching = false
