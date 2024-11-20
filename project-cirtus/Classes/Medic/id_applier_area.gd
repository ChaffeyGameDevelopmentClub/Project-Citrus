extends Area2D



var id: String = ""

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Match"):
		var prev_id = body.gem_data["id"]
		body.gem_data["id"]=id
		SignalBus.emit_signal("grid_update", id, body)
