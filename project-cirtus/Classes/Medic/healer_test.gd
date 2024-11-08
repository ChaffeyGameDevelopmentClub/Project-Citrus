extends CanvasLayer

@export var button: Button
@onready var shape = preload("res://Classes/Medic/matching_item.tscn")

var red = preload("res://test_sprites/00.png")
var green = preload("res://test_sprites/01.png")
var blue = preload("res://test_sprites/02.png")

var possible_shapes:Array = [red, green, blue]

var rows: int = 14
var columns: int = 5

var shape_size: int =40
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_grid()
	print(possible_shapes[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_pressed() -> void:
	print("hey")


func create_grid():
	for i in rows:
		for j in columns:
			var temp = shape.instantiate()
			add_child(temp)
			temp.position.x =j*40
			temp.position.y = i*40
			temp.button.texture_normal = possible_shapes[randi_range(0,possible_shapes.size()-1)] 
			#print(possible_shapes[randi_range(0,possible_shapes.size()-1)])
			#print(red)
			#print(temp.button.texture_normal)
