extends Area2D
@export var timer:Timer

var id:int = 0

func _ready() -> void:
	SignalBus.emit_signal("spawn_new_match", id)

func _on_body_exited(_body: Node2D) -> void:
	SignalBus.emit_signal("spawn_new_match", id)
