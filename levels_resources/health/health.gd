extends ShapeCast3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


@export var power := 1
func _physics_process(delta: float) -> void:
	rotation.y += delta * 4
	if is_colliding():
		for i in range(0,get_collision_count()):
			var b : Node3D = get_collider(i)
			if b.has_method("heal"):
				b.heal(power)
				queue_free()
