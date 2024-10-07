extends ShapeCast3D

@export var damage : int = 1
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
	if speed_y < 0 and $RayCast3D.is_colliding():
		speed_y = 4.0
	if enabled:
		for i in range(0,get_collision_count()):
			var b : Node3D = get_collider(i)
			if b == Global.player:
				b.hit(damage)
				enabled = false
				$explosion.emitting = true
				$bomb.visible = false
		
		if get_collision_count() > 0:
			enabled = false
			$explosion.emitting = true
			$bomb.visible = false
			


func _on_explosion_finished() -> void:
	queue_free()
	
