extends Node

const PickUp = preload("res://Inventory/Objects/pick_up.tscn")
@onready var player: CharacterBody3D = $InvTestWorld/Test_Inventory

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


func _on_inv_interface_drop_slot_data(slot_data: SlotData) -> void:
	print("Yosh!")
	var pick_up=PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.Get_drop_position()
	add_child(pick_up)
