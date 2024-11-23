extends Area2D
## Used to spawn potions at the top

var id:int = 0

func _ready() -> void:
	SignalBus.emit_signal("spawn_new_potion", id)

func _on_body_exited(_body: Node2D) -> void:
	SignalBus.emit_signal("spawn_new_potion", id)
