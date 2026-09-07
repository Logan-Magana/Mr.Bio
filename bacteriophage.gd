extends Area2D
@onready var eaten = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.assigned_animation = "eaten"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_macrophage_area_entered(area: Area2D):
	eaten += 0.1
	eaten = min(eaten, 1.0)
	$AnimationPlayer.seek(eaten, true)
