extends ShapeCast3D


@export var direction := -1.0
@export var speed := 8.0
func _ready() -> void:
	pass # Replace with function body.


var speed_y := 4.0
func _process(delta: float) -> void:
	
	rotation.z += -direction * speed * delta
	
	position.x += direction * speed * delta
	position.y += speed_y * delta
	
	speed_y -= delta * 9.8 * 2
	if $RayCast3D.is_colliding():
		speed_y = 4.0
