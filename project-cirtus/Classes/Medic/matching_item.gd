extends RigidBody2D

@export var button: TextureButton
@onready var texture = preload("res://test_sprites/00.png")

var id: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#button.texture_normal = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	print("ID: "+ str(id)+" Texture: "+ str(texture))
