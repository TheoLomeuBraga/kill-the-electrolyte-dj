extends Node3D


func set_glow(color:Color) -> void:
	$turret/Cylinder_002.mesh.surface_get_material(0).emission = color

func get_glow() -> Color:
	return $turret/Cylinder_002.mesh.surface_get_material(0).emission


func _ready() -> void:
	pass

@export var direction_x = 1

var state := 0

@export var health : = 3
func hit(damage: int):
	set_glow(Color.WHITE)
	health -= damage
	$sfx/hit.play()

func idle_state(delta: float) -> void:
	
	$turret/Cylinder_002/Cylinder_001/Cube/Cube_001.rotation_degrees.x = lerp($turret/Cylinder_002/Cylinder_001/Cube/Cube_001.rotation_degrees.x,-90.0,delta * 5.0)
	
	if (direction_x > 0 and Global.player.global_position.x - global_position.x > 0 ) or (direction_x < 0 and Global.player.global_position.x - global_position.x < 0 ):
		state = 1

@onready var muzle := $turret/Cylinder_002/Cylinder_001/Cube/Cube_001/muzle

var coldown := 0.0
@export var bullet : PackedScene
@export var range_distance : float = 10.0
func shot():
	var b : GPUParticles3D = bullet.instantiate()
	get_tree().get_root().add_child(b)
	b.global_transform = muzle.global_transform
	b.emitting = true
	$sfx/shot.play()

func aim_state(delta: float) -> void:
	if (direction_x > 0 and Global.player.global_position.x - global_position.x > 0 ) or (direction_x < 0 and Global.player.global_position.x - global_position.x < 0 ):
		if Global.player != null:
			var pp : Vector3 = Global.player.global_position
			pp.z = 0
			pp.y += 0.5
			$turret/Cylinder_002/Cylinder_001/Cube/Cube_001.look_at(pp,-Vector3.UP)
			$turret/Cylinder_002/Cylinder_001/Cube/Cube_001.rotation_degrees.x -= 90
			
			
			
			if global_position.distance_to(Global.player.global_position) < range_distance and coldown <= 0:
				shot()
				coldown = 0.5
	else:
		state = 0

var death := false
func death_state(delta: float) -> void:
	if not death:
		$StaticBody3D/CollisionShape3D.disabled = true
		$turret.visible = false
		$GPUParticles3D.emitting = true
		death = true
	


func _on_gpu_particles_3d_finished() -> void:
	queue_free()

func fade_glow(delta: float):
	set_glow(lerp(get_glow(),Color.BLACK,delta*4))



func _process(delta: float) -> void:
	
	fade_glow(delta)
	
	if health <= 0:
		state = 2
	
	if state == 0:
		idle_state(delta)
	elif state == 1:
		aim_state(delta)
	elif state == 2:
		death_state(delta)
	
	coldown -= delta
	
