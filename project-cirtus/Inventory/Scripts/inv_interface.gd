extends Control
@onready var player_inventory: PanelContainer = $"Player Inventory"

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	player_inventory.set_inventory_data(inventory_data)
	pass

func on_inventory_interact(inventory_data: InventoryData, index:int, button:int) -> void:
	pass
