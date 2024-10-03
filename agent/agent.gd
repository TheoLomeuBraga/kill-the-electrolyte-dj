extends CharacterBody3D

@onready var particle_muzle : GPUParticles3D = $model/particle_muzle


func _ready() -> void:
	$camera_basis/camera_basis_3D.global_position = global_position
	$camera_basis/camera_basis_3D.global_rotation = global_rotation
	particle_muzle.one_shot = true
	particle_muzle.emitting = false
	Global.player = self

func _exit_tree() -> void:
	Global.player = null

var state := 0

func manage_camera(delta: float) -> void:
	$camera_basis/camera_basis_3D.global_position = global_position

var air_progresion : float = 0.5
@export var floor_speed : float = 600.0

@onready var animationTree : AnimationTree = $model/agent/AnimationTree



var air_direction := Vector3.ZERO

var target_rot_y := 90.0
var freze_target_rot_y := 0.0

@export var bullet :PackedScene

var cooldown :float = 0.0

var ui_buttons : Dictionary = {
	"left": false,
	"right": false,
	"jump": false,
	"action": false,
}

func reset_ui_buttons():
	ui_buttons["jump"] = false
	ui_buttons["action"] = false

func shot():
	
	var b : Node3D= bullet.instantiate()
	get_tree().get_root().add_child(b)
	
	
	if target_rot_y < 0:
		target_rot_y = -90
		$model.rotation_degrees.y = -90
		b.direction.x = -1
	elif target_rot_y > 0:
		target_rot_y = 90
		$model.rotation_degrees.y = 90
		b.direction.x = 1
	
	b.global_position = $model/particle_muzle.global_position
	
	if cooldown <= 0:
		animationTree.set("parameters/shot/request",1)
		freze_target_rot_y = 0.2
		if not particle_muzle.emitting:
			particle_muzle.emitting = true
		cooldown = 0.1
		$sfx/shot.pitch_scale = rng.randf_range(1,1.25)
		$sfx/shot.play()

var step_cooldown := 0.0
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
func floor_state(delta: float) -> void:
	var direction := Vector3.ZERO
	
	if Input.is_action_pressed("left") or ui_buttons["left"]:
		direction.x = -1
		target_rot_y = -90
	elif Input.is_action_pressed("right") or ui_buttons["right"]:
		direction.x = 1
		target_rot_y = 90
	else:
		if target_rot_y == -90:
			target_rot_y = -45
		elif target_rot_y == 90:
			target_rot_y = 45
	
	if step_cooldown <= 0 and direction.x != 0:
		$sfx/step.pitch_scale = rng.randf_range(0.75,1.25)
		$sfx/step.play()
		step_cooldown = 0.25
		
	else:
		step_cooldown -= delta
	
	if freze_target_rot_y <= 0:
		$model.rotation_degrees.y = lerp($model.rotation_degrees.y,target_rot_y,delta * 20)
	
	var new_direction := Vector3.ZERO
	if $RayCastFloor.is_colliding(): 
		new_direction = direction.slide($RayCastFloor.get_collision_normal())
	elif $ShapeCastFloor.is_colliding():
		new_direction = direction.slide($ShapeCastFloor.get_collision_normal(0))
	else:
		state = 1
		air_progresion = 0.5
		animationTree.set("parameters/legs/transition_request","jump")
		animationTree.set("parameters/legs/transition_request","jump")
		air_direction = Vector3.ZERO
	
	if new_direction != Vector3.ZERO:
		direction = new_direction 
		air_direction = direction
	
	
	
	if Input.is_action_just_pressed("jump") or ui_buttons["jump"]:
		state = 1
		air_progresion = 0
		air_direction = direction
		animationTree.set("parameters/legs/transition_request","jump")
		animationTree.set("parameters/arms/transition_request","jump")
	
	velocity = direction * floor_speed * delta
	
	
	
	velocity.y -= 100 * delta
	
	animationTree.set("parameters/walk_speed/blend_position",Vector2(direction.x, direction.z).length())
	animationTree.set("parameters/arms_walk_speed/blend_position",Vector2(direction.x, direction.z).length() / 2.0)
	
	if Input.is_action_just_pressed("shot") or ui_buttons["action"]:
		shot()
	


@export var jump_curve : Curve
@export var jump_speed : float = 1200.0

func air_state(delta: float) -> void:
	
	
	if Input.is_action_pressed("left") or ui_buttons["left"]:
		air_direction.x += -5 * delta
	elif Input.is_action_pressed("right") or ui_buttons["right"]:
		air_direction.x += 5 * delta
	
	if air_direction.length() > 1:
		air_direction = air_direction.normalized()
	
	velocity = air_direction * floor_speed * delta
	
	if air_progresion < 0.5 and $ShapeCastCealing.is_colliding():
		air_progresion = 0.5
	
	velocity.y = jump_curve.sample(air_progresion) * jump_speed * delta
	
	
	
	if $RayCastFloor.is_colliding() and $ShapeCastFloor.is_colliding() and velocity.y < 0:
		state = 0
		animationTree.set("parameters/legs/transition_request","floor")
		animationTree.set("parameters/arms/transition_request","floor")
		$sfx/step.pitch_scale = 0.75
		$sfx/step.play()
	
	air_progresion += delta * 2
	
	if Input.is_action_just_pressed("shot") or ui_buttons["action"]:
		shot()
	
	if velocity.y < 0:
		if (target_rot_y < 0 and $grab_area/L/RayCast3D.is_colliding() and $grab_area/L/RayCast3D2.is_colliding()) or (target_rot_y > 0 and $grab_area/R/RayCast3D.is_colliding() and $grab_area/R/RayCast3D2.is_colliding()) :
			state = 2
			velocity = Vector3.ZERO
			$sfx/step.pitch_scale = 1.75
			$sfx/step.play()
	
	

func ledge_state(delta: float) -> void:
	
	animationTree.set("parameters/body_state/transition_request","ledje")
	
	if target_rot_y < 0:
		target_rot_y = -90
		$model.rotation_degrees.y = -90
		$model.position.x = -0.25
	elif target_rot_y > 0:
		target_rot_y = 90
		$model.rotation_degrees.y = 90
		$model.position.x = 0.25
		
	
	if Input.is_action_just_pressed("jump") or ui_buttons["jump"]:
		state = 1
		air_progresion = 0
		animationTree.set("parameters/body_state/transition_request","normal")
		$model.position = Vector3.ZERO
		
		if Input.is_action_pressed("left") or ui_buttons["left"]:
			target_rot_y = -90
			$model.rotation_degrees.y = -90
			air_direction.x = -1
		elif Input.is_action_pressed("right") or ui_buttons["right"]:
			target_rot_y = 90
			$model.rotation_degrees.y = 90
			air_direction.x = 1
		else:
			air_direction.x = 0
		

func _process(delta: float) -> void:
	manage_camera(delta)

func is_player():
	pass

func _physics_process(delta: float) -> void:
	
	
	if state == 0:
		floor_state(delta)
	elif state == 1:
		air_state(delta)
	elif state == 2:
		ledge_state(delta)
	
	$model/agent/Object/Skeleton3D/Cube_015/gun.visible = freze_target_rot_y > -1
	
	freze_target_rot_y -= delta
	cooldown -= delta
	move_and_slide()
	
	reset_ui_buttons()


func _on_left_pressed() -> void:
	ui_buttons["left"] = true

func _on_left_released() -> void:
	ui_buttons["left"] = false


func _on_right_pressed() -> void:
	ui_buttons["right"] = true

func _on_right_released() -> void:
	ui_buttons["right"] = false





func _on_jump_pressed() -> void:
	ui_buttons["jump"] = true


func _on_action_pressed() -> void:
	ui_buttons["action"] = true
