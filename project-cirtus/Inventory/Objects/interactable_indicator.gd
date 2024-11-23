extends Sprite3D

var in_motion = false
@onready var spin: AnimationPlayer = $Spin


func _process(delta: float) -> void:
	if in_motion == false:
		in_motion = true
		spin.play("interactable")
		await(spin.animation_finished)
		in_motion = false
