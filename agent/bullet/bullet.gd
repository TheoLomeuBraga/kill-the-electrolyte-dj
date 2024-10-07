extends MeshInstance3D


@export var direction := Vector3.ZERO
@export var speed := 20.0

func _physics_process(delta: float) -> void:
	position.x += direction.x * speed * delta
	
	if $ShapeCast3D.is_colliding():
		for i in range(0,$ShapeCast3D.get_collision_count()):
			if not $ShapeCast3D.get_collider(i).has_method("is_player"):
				
				if $ShapeCast3D.get_collider(i).get_parent().has_method("hit"):
					$ShapeCast3D.get_collider(i).get_parent().hit(1)
					
				if $ShapeCast3D.get_collider(i).has_method("hit"):
					$ShapeCast3D.get_collider(i).hit(1)
		queue_free()
