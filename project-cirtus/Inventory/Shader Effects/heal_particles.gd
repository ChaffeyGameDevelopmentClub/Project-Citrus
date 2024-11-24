extends RigidBody3D
@onready var heal_particles: GPUParticles3D = $HealParticles


func _ready() -> void:
	heal_particles.emitting=true


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
