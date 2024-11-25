extends Area2D


## ID of that cell
var id: String = ""

## whenever a new potion enters this, it sends a signal to the main, telling it to change that potions data
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Potion"):
		body.potion_data["id"]=id
		SignalBus.emit_signal("grid_update", id, body)
