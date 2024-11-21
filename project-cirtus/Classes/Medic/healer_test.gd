#extends Node2D
extends CanvasLayer
#extends Control

@export var falling_timer:Timer
@export var label:Label

@onready var shape = preload("res://Classes/Medic/matching_item.tscn")
var applier = preload("res://Classes/Medic/id_applier_area.tscn")
var spawner = preload("res://Classes/Medic/match_spawner.tscn")

var red = preload("res://test_sprites/00.png")
var green = preload("res://test_sprites/01.png")
var blue = preload("res://test_sprites/02.png")

var red_pressed = preload("res://icon.svg")
var green_pressed = preload("res://icon.svg")
var blue_pressed = preload("res://icon.svg")

var button_disabler = preload("res://Classes/Medic/button_disabler.tscn")
var new_disabler = button_disabler.instantiate()

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

var stable_bodies:int =0

var total_points:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("match_clicked", update_clicked)
	SignalBus.connect("grid_update", update_grid)
	SignalBus.connect("spawn_new_match", spawn_new_match)
	for i in rows:
		gem_grid.append({})
	create_grid()
	create_appliers()
	create_spawners()
	add_child(new_disabler)
	
	#print(gem_grid)

func update_button_disabler():
	new_disabler.move_to_front()

func spawn_new_match(id:int):
	possible_shapes = [red, green, blue]
	var gem = possible_shapes[randi_range(0,possible_shapes.size()-1)]
	
	var new_shape = shape.instantiate()
	new_shape.position = Vector2(id*shape_size+x_offset, -shape_size) 
	new_shape.gem_data = {
		"id":"0"+str(id),
		"normal_texture": gem,
		"pressed_texture":pressed_textures[gem]
	}
	new_shape.button.texture_normal = gem
	new_shape.button.texture_pressed = pressed_textures[gem]
	call_deferred("add_child", new_shape)
	new_disabler.move_to_front()


func create_spawners():
	for i in columns:
		var new_spawner = spawner.instantiate()
		@warning_ignore("integer_division")
		new_spawner.position = Vector2(i*shape_size+x_offset+shape_size/2, -shape_size/2) 
		new_spawner.id = i
		add_child(new_spawner)

func create_appliers():
	for i in columns:
		for j in rows:
			var new_applier = applier.instantiate()
			@warning_ignore("integer_division")
			new_applier.position.x =i*shape_size+x_offset+shape_size/2
			@warning_ignore("integer_division")
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
	for i in range(0,3):
		@warning_ignore("integer_division")
		check_horiz(first_id%10+i, int(first_id/10))
		@warning_ignore("integer_division")
		check_horiz(second_id%10+i, int(second_id/10))
		@warning_ignore("integer_division")
		check_vert(first_id%10, int(first_id/10+i))
		@warning_ignore("integer_division")
		check_vert(second_id%10, int(second_id/10+i))
	matched_tiles = remove_duplicates(matched_tiles)


func check_horiz(i:int,j:int):
	if i>1:
		if i<9&&j<9:
			var h_gem = gem_grid[j][str(j)+str(i-2)].button.texture_normal
			if h_gem == gem_grid[j][str(j)+str(i-1)].button.texture_normal && h_gem==gem_grid[j][str(j)+str(i)].button.texture_normal:
				#print("H COMBO")
				matched_tiles.append(str(j)+str(i))
				matched_tiles.append(str(j)+str(i-1))
				matched_tiles.append(str(j)+str(i-2))



func check_vert(i:int, j:int):
	if j>1:
		if i<9&&j<9:
			var v_gem = gem_grid[j-2][str(j-2)+str(i)].button.texture_normal
			if v_gem==gem_grid[j-1][str(j-1)+str(i)].button.texture_normal && v_gem == gem_grid[j][str(j)+str(i)].button.texture_normal:
				#print("V COMBO")
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
	total_points+= tiles.size()*10
	label.text = str(total_points)
	


func update_grid(id:String, body:Node):
	gem_grid[int(id[0])][id]=body


func check_grid():
	for i in columns:
		for j in rows:
			gem_grid[j][str(j)+str(i)].get_child(1).mouse_filter = 0
			check_vert(i,j)
			check_horiz(i,j)


func _on_falling_checker_body_entered(body: Node2D) -> void:
	if body.is_in_group("Match"):
		stable_bodies+=1
		falling_timer.stop()
		if stable_bodies==9:
			falling_timer.start(.25)


func _on_falling_checker_body_exited(body: Node2D) -> void:
	if body.is_in_group("Match"):
		#print("cool")
		stable_bodies-=1
		if new_disabler.mouse_filter==2:
			new_disabler.mouse_filter = 0
		falling_timer.stop()

func _on_timer_timeout() -> void:
	check_grid()
	new_disabler.mouse_filter = 2
	remove_matches(matched_tiles)
	matched_tiles.clear()
	falling_timer.stop()
