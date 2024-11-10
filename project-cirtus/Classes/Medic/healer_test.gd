extends CanvasLayer

@export var button: Button
@onready var shape = preload("res://Classes/Medic/matching_item.tscn")

var red = preload("res://test_sprites/00.png")
var green = preload("res://test_sprites/01.png")
var blue = preload("res://test_sprites/02.png")

var possible_shapes:Array = [red, green, blue]

var rows: int = 13
var columns: int = 12

var x_offset = 20
var y_offset = 0

var gem_grid:Array =[]

var shape_size: int =40
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in rows:
		gem_grid.append({})
	create_grid()
	print(gem_grid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func create_grid():
	for i in columns:
		for j in rows:
			possible_shapes = [red, green, blue]
			var temp = shape.instantiate()
			var gem:CompressedTexture2D 
			if j<2:
				if i>1:
					check_horiz(i,j)
			else:
				if i>1:
					check_horiz(i,j)
				check_vert(i,j)
			gem = possible_shapes[randi_range(0,possible_shapes.size()-1)]
			gem_grid[j][str(j)+str(i)] = temp
			add_child(temp)
			temp.position.x =i*shape_size+x_offset
			temp.position.y = j*shape_size+y_offset
			temp.button.texture_normal = gem
			temp.id = str(j)+str(i)
			

func check_horiz(i: int, j: int):
	var h_gem = gem_grid[j][str(j)+str(i-2)].button.texture_normal
	if h_gem == gem_grid[j][str(j)+str(i-1)].button.texture_normal:
		possible_shapes.erase(h_gem)

func check_vert(i: int, j: int):
	var v_gem = gem_grid[j-2][str(j-2)+str(i)].button.texture_normal
	if v_gem==gem_grid[j-1][str(j-1)+str(i)].button.texture_normal:
		possible_shapes.erase(v_gem)
