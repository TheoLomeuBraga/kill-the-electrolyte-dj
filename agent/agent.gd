extends CharacterBody3D



func _ready() -> void:
	$camera_basis/camera_basis_3D.global_position = global_position
	$camera_basis/camera_basis_3D.global_rotation = global_rotation

var state := 0

func manage_camera(delta: float) -> void:
	$camera_basis/camera_basis_3D.global_position = lerp($camera_basis/camera_basis_3D.global_position,global_position,delta * 100)

var air_progresion : float = 0.5
@export var floor_speed : float = 600.0

func floor_state(delta: float) -> void:
	var direction := Vector3.ZERO
	
	if $RayCastFloor.is_colliding():
		direction = direction.slide($RayCastFloor.get_collision_normal())
	elif $ShapeCastFloor.is_colliding():
		direction = direction.slide($ShapeCastFloor.get_collision_normal(0))
	else:
		state = 1
		air_progresion = 0.5
	
	if Input.is_action_pressed("left"):
		direction.x = -1
	elif Input.is_action_pressed("right"):
		direction.x = 1
	
	if Input.is_action_just_pressed("jump"):
		state = 1
		air_progresion = 0
	
	velocity = direction * floor_speed * delta
	
	velocity.y -= 100 * delta

@export var jump_curve : Curve
@export var jump_speed : float = 1200.0

func air_state(delta: float) -> void:
	var direction := Vector3.ZERO
	
	if Input.is_action_pressed("left"):
		direction.x = -1
	elif Input.is_action_pressed("right"):
		direction.x = 1
	
	velocity = direction * floor_speed * delta
	
	if air_progresion < 0.5 and $ShapeCastCealing.is_colliding():
		air_progresion = 0.5
	
	velocity.y = jump_curve.sample(air_progresion) * jump_speed * delta
	
	
	
	if $RayCastFloor.is_colliding() and $ShapeCastFloor.is_colliding() and velocity.y < 0:
		state = 0
	
	air_progresion += delta

func _process(delta: float) -> void:
	manage_camera(delta)
	
	if state == 0:
		floor_state(delta)
	elif state == 1:
		air_state(delta)
	
	move_and_slide()
