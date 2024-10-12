extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("is_agent"):
		body.block_gun = true

func _on_body_exited(body: Node3D) -> void:
	if body.has_method("is_agent"):
		body.block_gun = false
		
