extends Area2D
@export var real_texture: Texture2D
@export var fake_texture: Texture2D

var is_real: bool = true
var velocity: Vector2 = Vector2.ZERO
var screen_size: Vector2
signal target_clicked(real)
signal target_timeout()
# Called when the node enters the scene tree for the first time.
func _ready():
	if is_real == true:
		$Sprite2D.texture = real_texture
	else:
		$Sprite2D.texture = fake_texture
	screen_size = get_viewport_rect().size
	velocity = Vector2(randf_range(-80,80), randf_range(-80,80))
	$Timer.wait_time = randf_range(2.0,5.0)
	$Timer.start()
	input_event.connect(_on_input_event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity*delta
	if position.x < 0 or position.x > screen_size.x:
		velocity.x *= -1
	if position.y < 0 or position.y > screen_size.y:
		velocity.y *= -1

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			target_clicked.emit(is_real)
	


func _on_timer_timeout():
	target_timeout.emit()
	queue_free()
	
