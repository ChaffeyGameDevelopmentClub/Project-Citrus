extends Area2D



var gem = null



func _on_body_entered(body: Node2D) -> void:
	gem = body


func _on_body_exited(body: Node2D) -> void:
	gem = null
	
