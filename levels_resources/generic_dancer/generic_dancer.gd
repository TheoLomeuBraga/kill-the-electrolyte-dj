extends Node3D


var rng : RandomNumberGenerator = RandomNumberGenerator.new()
func _ready() -> void:
	$generic_dancer/AnimationPlayer.speed_scale = rng.randf_range(0.75,1.25)
	rotation_degrees.y = rng.randf_range(0,360)



func _process(delta: float) -> void:
	$generic_dancer/AnimationPlayer.play("generic dance")
