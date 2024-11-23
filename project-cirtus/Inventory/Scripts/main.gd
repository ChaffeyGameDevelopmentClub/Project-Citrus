extends Node

@onready var test_inventory: CharacterBody3D = $InvTestWorld/Test_Inventory
@onready var inv_interface: Control = $"InvTestWorld/UI/Inv Interface"

func _ready() -> void:
	inv_interface.set_player_inventory_data(test_inventory.inventory_data)
	test_inventory.toggle_inventory.connect(toggle_inventory_interface)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
	
func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inv_interface.visible =  not inv_interface.visible
	if external_inventory_owner and inv_interface.visible:
		inv_interface.set_external_inventory(external_inventory_owner)
	else:
		inv_interface.clear_external_inventory()
		pass
	pass
