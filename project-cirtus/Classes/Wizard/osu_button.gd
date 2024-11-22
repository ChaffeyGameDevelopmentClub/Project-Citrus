extends TextureButton

signal create_button

var rune_color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_down() -> void:
	SignalBus.emit_signal("update_runes", rune_color)
	queue_free()
