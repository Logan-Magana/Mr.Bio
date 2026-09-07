extends Area2D
class_name HealthyCell
var velocity: Vector2 = Vector2.ZERO
var screen_size_half: Vector2
signal cell_timeout()
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size_half = get_viewport_rect().size
	velocity = Vector2(randf_range(-80,80), randf_range(-80,80))
	position = Vector2(randf_range(50,430), randf_range(50,130))
	if velocity.x <= 0:
		$Sprite2D.flip_h = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity*delta
	if position.x < 0:
		velocity.x *= -1
		$Sprite2D.flip_h = false
	elif position.x > screen_size_half.x:
		$Sprite2D.flip_h = true
		velocity *= -1
	elif position.y < 0 or position.y > screen_size_half.y / 2:
		velocity.y *= -1
		
func _on_timer_timeout():
	cell_timeout.emit()
	queue_free()
