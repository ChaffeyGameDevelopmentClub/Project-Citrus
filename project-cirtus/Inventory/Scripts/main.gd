extends Node

@onready var test_inventory: CharacterBody3D = $InvTestWorld/Test_Inventory
@onready var inv_interface: Control = $"InvTestWorld/UI/Inv Interface"

func _ready() -> void:
	inv_interface.set_player_inventory_data(test_inventory.inventory_data)
	test_inventory.toggle_inventory.connect(toggle_inventory_interface)
	
func toggle_inventory_interface() -> void:
	inv_interface.visible =  not inv_interface.visible
	pass
