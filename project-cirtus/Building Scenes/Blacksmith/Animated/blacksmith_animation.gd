extends Node3D

var is_playing = false

func _process(delta: float) -> void:
	if is_playing ==false:
		is_playing = true;
		$AnimationPlayer.play("BlackSmith")
		await($AnimationPlayer.animation_finished)
		is_playing=false;
