extends Node3D


var rng : RandomNumberGenerator = RandomNumberGenerator.new()
func _ready() -> void:
	$SpotLight3D.light_color.s = 1
	$SpotLight3D.light_color.v = 1
	
	$SpotLight3D.light_color.h = rng.randf_range(0,1)

func _process(delta: float) -> void:
	$SpotLight3D.light_color.h += delta / 5
	if $SpotLight3D.light_color.h > 1:
		$SpotLight3D.light_color.h -= 1
