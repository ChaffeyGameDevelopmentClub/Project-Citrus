extends RigidBody2D

@export var button: TextureButton

@onready var texture = preload("res://test_sprites/00.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.texture_normal = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
