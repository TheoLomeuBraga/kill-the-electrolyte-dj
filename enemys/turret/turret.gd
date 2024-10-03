extends Node3D



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Global.player != null:
		var pp : Vector3 = Global.player.global_position
		pp.z = 0
		$turret/Cylinder_002/Cylinder_001/Cube/Cube_001.look_at(pp,-Vector3.UP)
		$turret/Cylinder_002/Cylinder_001/Cube/Cube_001.rotation_degrees.x -= 90
