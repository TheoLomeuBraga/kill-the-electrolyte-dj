extends PathFollow3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func is_plataform():
	pass

@export var speed := 3.0
func _physics_process(delta: float) -> void:
	progress += delta * speed
