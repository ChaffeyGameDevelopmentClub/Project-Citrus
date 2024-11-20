extends CanvasLayer

@onready var shape = preload("res://Classes/Medic/matching_item.tscn")
var applier = preload("res://Classes/Medic/id_applier_area.tscn")
var spawner = preload("res://Classes/Medic/match_spawner.tscn")


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

var shape_size: int = 50
var rows: int = 9
var columns: int = 9
var x_offset = 20
var y_offset = 0

var gem_grid:Array =[]

var first_click_data:Dictionary
var second_click_data:Dictionary

var on_first: bool = true

var matched_tiles:Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("match_clicked", update_clicked)
	SignalBus.connect("grid_update", update_grid)
	for i in rows:
		gem_grid.append({})
	create_grid()
	create_appliers()
	#print(gem_grid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_spawners():
	pass

func create_appliers():
	for i in columns:
		for j in rows:
			var new_applier = applier.instantiate()
			new_applier.position.x =i*shape_size+x_offset+shape_size/2
			new_applier.position.y = j*shape_size+y_offset+shape_size/2
			new_applier.id = str(j)+str(i)
			add_child(new_applier)

func create_grid():
	for i in columns:
		for j in rows:
			possible_shapes = [red, green, blue]
			var temp = shape.instantiate()
			var gem:CompressedTexture2D 
			if j<2:
				if i>1:
					begin_check_horiz(i,j)
			else:
				if i>1:
					begin_check_horiz(i,j)
				begin_check_vert(i,j)
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


func begin_check_horiz(i: int, j: int):
	var h_gem = gem_grid[j][str(j)+str(i-2)].button.texture_normal
	if h_gem == gem_grid[j][str(j)+str(i-1)].button.texture_normal:
		possible_shapes.erase(h_gem)

func begin_check_vert(i: int, j: int):
	var v_gem = gem_grid[j-2][str(j-2)+str(i)].button.texture_normal
	if v_gem==gem_grid[j-1][str(j-1)+str(i)].button.texture_normal:
		possible_shapes.erase(v_gem)

func update_clicked(data):
	if on_first:
		first_click_data = {
			"id":data["id"],
			"normal_texture":data["normal_texture"],
			"pressed_texture":data["pressed_texture"]
		}
		on_first = false
	else:
		second_click_data = {
			"id":data["id"],
			"normal_texture":data["normal_texture"],
			"pressed_texture":data["pressed_texture"]
		}
		if check_if_neighbors():
			swap()
			check_for_combos()
			remove_matches(matched_tiles)
			matched_tiles.clear()
		on_first = true
		untoggle()
		

func check_if_neighbors()->bool:
	var first = int(first_click_data["id"])
	var second = int(second_click_data["id"])
	if first == second-10 || first== second+10 || first== second-1 || first == second+1:
		return true
	return false

func untoggle():
	gem_grid[int(first_click_data["id"][0])][first_click_data["id"]].get_child(1).button_pressed = false
	gem_grid[int(second_click_data["id"][0])][second_click_data["id"]].get_child(1).button_pressed = false

func swap():
	gem_grid[int(second_click_data["id"][0])][second_click_data["id"]].swap(first_click_data)
	gem_grid[int(first_click_data["id"][0])][first_click_data["id"]].swap(second_click_data)

func check_for_combos():
	var first_id:int= int(first_click_data["id"])
	var second_id:int = int(second_click_data["id"])
	print(first_id)
	print(second_id)
	for i in range(0,3):
		check_horiz(first_id%10+i, int(first_id/10))
		check_horiz(second_id%10+i, int(second_id/10))
		check_vert(first_id%10, int(first_id/10+i))
		check_vert(second_id%10, int(second_id/10+i))
	matched_tiles = remove_duplicates(matched_tiles)


func check_horiz(i:int,j:int):
	if i>1:
		if i<9&&j<9:
			var h_gem = gem_grid[j][str(j)+str(i-2)].button.texture_normal
			if h_gem == gem_grid[j][str(j)+str(i-1)].button.texture_normal && h_gem==gem_grid[j][str(j)+str(i)].button.texture_normal:
				print("H COMBO")
				matched_tiles.append(str(j)+str(i))
				matched_tiles.append(str(j)+str(i-1))
				matched_tiles.append(str(j)+str(i-2))



func check_vert(i:int, j:int):
	if j>1:
		if i<9&&j<9:
			var v_gem = gem_grid[j-2][str(j-2)+str(i)].button.texture_normal
			if v_gem==gem_grid[j-1][str(j-1)+str(i)].button.texture_normal && v_gem == gem_grid[j][str(j)+str(i)].button.texture_normal:
				print("V COMBO")
				matched_tiles.append(str(j)+str(i))
				matched_tiles.append(str(j-1)+str(i))
				matched_tiles.append(str(j-2)+str(i))

func remove_duplicates(arr:Array)->Array:
	var temp = []
	for i in arr:
		if i not in temp:
			temp.append(i)
	return temp

func remove_matches(tiles:Array):
	for i in tiles:
		gem_grid[int(i[0])][i].die()


func update_grid(id:String, body:Node):
	print("hey")
	gem_grid[int(id[0])][id]=body
