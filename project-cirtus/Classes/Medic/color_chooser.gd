extends TextureButton

@export var color: String = ""


func _on_pressed() -> void:
	SignalBus.emit_signal("color_picked", color)
