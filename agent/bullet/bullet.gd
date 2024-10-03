extends MeshInstance3D


@export var direction := Vector3.ZERO
@export var speed := 20.0

func _physics_process(delta: float) -> void:
	position.x += direction.x * speed * delta
	
	if $ShapeCast3D.is_colliding():
		for i in range(0,$ShapeCast3D.get_collision_count()):
			if not $ShapeCast3D.get_collider(i).has_method("is_player"):
				queue_free()
