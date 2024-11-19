extends CanvasLayer

@onready var shape = preload("res://Classes/Medic/matching_item.tscn")

var red = preload("res://test_sprites/00.png")
var green = preload("res://test_sprites/01.png")
var blue = preload("res://test_sprites/02.png")

var red_pressed = preload("res://icon.svg")
var green_pressed = preload("res://icon.svg")
var blue_pressed = preload("res://icon.svg")

var possible_shapes:Array = [red, green, blue]

var pressed_textures = {
	red: red_pressed,
	green:green_pressed,
	blue:blue_pressed
}

var shape_size: int =50
var rows: int = 9
var columns: int = 9
var x_offset = 20
var y_offset = 0

var gem_grid:Array =[]

var first_click_data:Dictionary
var second_click_data:Dictionary

var temp

var on_first: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("match_clicked", update_clicked)
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
			temp.button.texture_pressed = pressed_textures[gem]
			temp.gem_data["normal_texture"] = gem
			temp.gem_data["pressed_texture"] = pressed_textures[gem]
			temp.gem_data["id"] = str(j)+str(i)


func check_horiz(i: int, j: int):
	var h_gem = gem_grid[j][str(j)+str(i-2)].button.texture_normal
	if h_gem == gem_grid[j][str(j)+str(i-1)].button.texture_normal:
		possible_shapes.erase(h_gem)

func check_vert(i: int, j: int):
	var v_gem = gem_grid[j-2][str(j-2)+str(i)].button.texture_normal
	if v_gem==gem_grid[j-1][str(j-1)+str(i)].button.texture_normal:
		possible_shapes.erase(v_gem)

func update_clicked(data):
	if on_first:
		first_click_data = data
		on_first = false
		temp = data
	else:
		second_click_data = data
		if check_if_neighbors():
			print("Neighbor")
			gem_grid[int(second_click_data["id"][0])][second_click_data["id"]].swap(first_click_data)
			gem_grid[int(first_click_data["id"][0])][first_click_data["id"]].swap(second_click_data)
		on_first = true
		gem_grid[int(first_click_data["id"][0])][first_click_data["id"]].get_child(1).button_pressed = false
		gem_grid[int(second_click_data["id"][0])][second_click_data["id"]].get_child(1).button_pressed = false
		

func check_if_neighbors()->bool:
	var first = int(first_click_data["id"])
	var second = int(second_click_data["id"])
	if first == second-10 || first== second+10 || first== second-1 || first == second+1:
		return true
	return false

#func swap():
	#var temp = first_click_data
	#first_click_data = second_click_data
	#second_click_data = temp
	#SignalBus.emit_signal("match_update", first_click_data, second_click_data)
