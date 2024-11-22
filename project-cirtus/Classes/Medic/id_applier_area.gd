extends Area2D



var id: String = ""

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Potion"):
		body.potion_data["id"]=id
		SignalBus.emit_signal("grid_update", id, body)
