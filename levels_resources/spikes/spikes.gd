extends ShapeCast3D



func _physics_process(delta: float) -> void:
	if is_colliding():
		for i in range(0,get_collision_count()):
			var body : Node3D = get_collider(i)
			if body.has_method("is_agent"):
				if body.invencibility_time <= 0:
					body.hit(1)
					body.invencibility_time = 1.0
