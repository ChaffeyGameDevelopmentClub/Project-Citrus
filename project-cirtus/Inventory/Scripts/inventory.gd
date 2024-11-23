extends PanelContainer

const Slot = preload("res://Inventory/GUI/slot.tscn")
@onready var item_grid : GridContainer = $MarginContainer/ItemGrid

#func _ready() -> void:
#	var inv_data = preload("res://Inventory/test/player_test.tres")
#	populate_grid(inv_data.slot_datas)	

#func _process(delta: float) -> void:
#	var new_data = preload("res://Inventory/test/player_test.tres")
#	populate_grid(new_data.slot_datas)
#	pass

func set_inventory_data(inventory_data: InventoryData) -> void:
	populate_grid(inventory_data)
	pass

func populate_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		if slot_data:
			slot.set_slot_data(slot_data)
			pass
