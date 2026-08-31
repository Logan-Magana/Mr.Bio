extends Area2D
var screen_size
var points = 0
@export var speed = 400
signal cell_signaled
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	area_entered.connect(_on_area_entered)
	$CellTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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


func _on_area_entered(area):
	if area is HealthyCell:
		points += 1
		$SFX.play()
		area.queue_free()
		cell_signaled.emit()
		print(points)
func _on_cell_timer_timeout():
	position = Vector2(230,190)
	$CellTimer.start()
