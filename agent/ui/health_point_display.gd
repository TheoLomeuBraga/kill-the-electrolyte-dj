extends Panel





@export var has_health = true
func _process(delta: float) -> void:
	$point.visible = has_health
