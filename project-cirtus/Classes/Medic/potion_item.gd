extends RigidBody2D

@export var button: TextureButton
#@onready var texture = preload("res://test_sprites/00.png")
## records the data of the potion
@onready var potion_data:Dictionary ={
	"id":"",
	"normal_texture":button.texture_normal,
	"pressed_texture":button.texture_pressed
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#SignalBus.connect("potion_match_update", update_texture)

## sends a signal to the main whenever its pressed
func _on_texture_button_pressed() -> void:
	SignalBus.emit_signal("potion_clicked", potion_data)
	#print("ID: "+ str(potion_data["id"])+" Texture: "+ str(potion_data["normal_texture"]))


'''
func update_texture(data_1:Dictionary, data_2:Dictionary):
	if potion_data["id"]==data_1["id"]:
		potion_data["normal_texture"] = data_2["normal_texture"]
		potion_data["pressed_texture"] = data_2["pressed_texture"]
		print(potion_data)
	elif potion_data["id"]==data_2["id"]:
		potion_data["normal_texture"] = data_1["normal_texture"]
		potion_data["pressed_texture"] = data_1["pressed_texture"]
		print(potion_data)
	
	button.texture_normal = potion_data["normal_texture"]
	button.texture_pressed = potion_data["pressed_texture"]

func swap(data:Dictionary):
	potion_data["normal_texture"] = data["normal_texture"]
	potion_data["pressed_texture"] = data["pressed_texture"]
	button.texture_normal = potion_data["normal_texture"]
	button.texture_pressed = potion_data["pressed_texture"]
'''
## clears the potion
func die():
	queue_free()
