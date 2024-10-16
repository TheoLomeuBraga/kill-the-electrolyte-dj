extends StaticBody3D

var death : bool = false
func hit(damage :int):
	if death == false:
		$js_electrolight.visible = false
		$GPUParticles3D.emitting = true
		death = true
	

func _on_gpu_particles_3d_finished() -> void:
	Global.contract_complete()
	queue_free()
