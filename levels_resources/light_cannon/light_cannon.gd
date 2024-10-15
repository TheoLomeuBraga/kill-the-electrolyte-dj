extends Node3D


@export var normal_light : bool = false
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
func _ready() -> void:
	if not normal_light:
		$SpotLight3D.light_color.s = 1
		$SpotLight3D.light_color.v = 1
		$SpotLight3D.light_color.h = rng.randf_range(0,1)
	else:
		$SpotLight3D.light_color = Color.WHITE

func _process(delta: float) -> void:
	
	
	
	if not normal_light:
		$SpotLight3D.light_color.h += delta / 5
		if $SpotLight3D.light_color.h > 1:
			$SpotLight3D.light_color.h -= 1
