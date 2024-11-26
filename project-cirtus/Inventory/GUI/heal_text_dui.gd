extends Label

func _process(delta: float) -> void:
	position.y -= delta * 120
#quantity_label.text = "x%s" % slot_data.quantity
func Heal_text(input:int) -> void:
	self.text="%s" % input 
func _on_timer_timeout() -> void:
	queue_free()
