extends CharacterBody3D



func _ready() -> void:
	pass



func set_glow(color: Color) -> void:
	$model/smal_robot/Cube.mesh.surface_get_material(0).emission = color

func get_glow() -> Color:
	return $model/smal_robot/Cube.mesh.surface_get_material(0).emission

func fade_glow(delta: float) -> void:
	set_glow(lerp(get_glow(),Color.BLACK,delta*4))


@export var health : = 4
func hit(damage: int) -> void:
	set_glow(Color.WHITE)
	health -= damage
	$sfx/hit.play()

@export var bomb : PackedScene
func shoot():
	$sfx/shot.play()
	
	var b : Node3D = bomb.instantiate()
	get_tree().get_root().add_child(b)
	b.global_position = $model/muzle.global_position
	
	b.direction = direction_x
	
	
	if not $model/muzle_particle.emitting:
		$model/muzle_particle.emitting = true

var coldowm := 0.5
@export var range_distance : float = 10.0
@export var direction_x := -1

var state := 0

func idle_state(delta: float) -> void:
	if Global.player != null and global_position.distance_to(Global.player.global_position) < range_distance:
		state = 1

var target_rotation_y := 90.0
func shot_state(delta: float) -> void:
	if Global.player != null and global_position.distance_to(Global.player.global_position) > range_distance:
		state = 0
	
	$model.rotation_degrees.y = lerp($model.rotation_degrees.y,target_rotation_y, delta * 15.0) 
	
	if coldowm <= 0:
		shoot()
		coldowm = 2.0

var death := false
func death_state(delta: float) -> void:
	if not death:
		$CollisionShape3D.disabled = true
		$model.visible = false
		$GPUParticles3D.emitting = true
		death = true

func _on_gpu_particles_3d_finished() -> void:
	queue_free()

func _process(delta: float) -> void:
	
	
	fade_glow(delta)
	
	if health <= 0:
		state = 2
	
	if state == 0:
		idle_state(delta)
	if state == 1:
		shot_state(delta)
	if state == 2:
		death_state(delta)
	
	
	
	coldowm -= delta
