extends RigidBody2D

@export var button: TextureButton
#@onready var texture = preload("res://test_sprites/00.png")

@onready var gem_data:Dictionary ={
	"id":"",
	"normal_texture":button.texture_normal,
	"pressed_texture":button.texture_pressed
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("match_update", update_texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	SignalBus.emit_signal("match_clicked", gem_data)
	print("ID: "+ str(gem_data["id"])+" Texture: "+ str(gem_data["normal_texture"]))

func update_texture(data_1:Dictionary, data_2:Dictionary):
	if gem_data["id"]==data_1["id"]:
		gem_data["normal_texture"] = data_2["normal_texture"]
		gem_data["pressed_texture"] = data_2["pressed_texture"]
		print(gem_data)
	elif gem_data["id"]==data_2["id"]:
		gem_data["normal_texture"] = data_1["normal_texture"]
		gem_data["pressed_texture"] = data_1["pressed_texture"]
		print(gem_data)
	
	button.texture_normal = gem_data["normal_texture"]
	button.texture_pressed = gem_data["pressed_texture"]

func swap(data:Dictionary):
	gem_data["normal_texture"] = data["normal_texture"]
	gem_data["pressed_texture"] = data["pressed_texture"]
	button.texture_normal = gem_data["normal_texture"]
	button.texture_pressed = gem_data["pressed_texture"]

func die():
	queue_free()
