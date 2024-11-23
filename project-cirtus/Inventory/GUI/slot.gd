extends PanelContainer

signal slot_clicked(index:int, button: int)

@onready var quantity_label: Label = $QuantityLabel
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.item_texture
	tooltip_text = "$s\n$s" % [item_data.item_name, item_data.item_description]
	
	if slot_data.quantity >1:
		quantity_label.text = "x%s" % slot_data.quantity
		quantity_label.show()
	pass



func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT \
		or event.button_index == MOUSE_BUTTON_RIGHT) \
		and event.is_pressed():
			slot_clicked.emit(get_index(),event.button_index)
	pass # Replace with function body.