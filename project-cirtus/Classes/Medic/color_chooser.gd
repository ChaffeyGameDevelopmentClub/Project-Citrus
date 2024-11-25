extends TextureButton

## The color associated with this button
@export var color: String = ""

## Sends a signal to main saying what color the player chose
func _on_pressed() -> void:
	SignalBus.emit_signal("color_picked", color)
