extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var damage : int = 1
@export var bullet_life_time : float = 2.0
func _physics_process(delta: float) -> void:
	bullet_life_time -= delta
	
	$MeshInstance3D.position.y -= delta * 20
	
	if $MeshInstance3D/ShapeCast3D.is_colliding():
		for i in range(0,$MeshInstance3D/ShapeCast3D.get_collision_count()):
			var b : Node3D = $MeshInstance3D/ShapeCast3D.get_collider(i)
			if b == Global.player:
				b.hit(damage)
		$MeshInstance3D.visible = false
		$MeshInstance3D/ShapeCast3D.enabled = false
	
	
	if bullet_life_time <= 0:
		queue_free()
	
