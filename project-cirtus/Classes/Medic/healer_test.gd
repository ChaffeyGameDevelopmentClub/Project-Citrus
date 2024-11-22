#extends Node2D
extends CanvasLayer
#extends Control

@export var falling_timer:Timer
@export var label:Label

@onready var potion = preload("res://Classes/Medic/potion_item.tscn")
var applier = preload("res://Classes/Medic/id_applier_area.tscn")
var spawner = preload("res://Classes/Medic/potion_spawner.tscn")

var red = preload("res://test_sprites/00.png")
var green = preload("res://test_sprites/01.png")
var blue = preload("res://test_sprites/02.png")
var yellow = preload("res://test_sprites/03.png")
var purple = preload("res://test_sprites/04.png")

var red_pressed = preload("res://icon.svg")
var green_pressed = preload("res://icon.svg")
var blue_pressed = preload("res://icon.svg")
var yellow_pressed = preload("res://icon.svg")
var purple_pressed = preload("res://icon.svg")

var input_disabler = preload("res://Classes/Medic/input_disabler.tscn")
var new_disabler = input_disabler.instantiate()

var possible_potions:Array = [red, green, blue, yellow, purple]

var pressed_textures = {
	red: red_pressed,
	green:green_pressed,
	blue:blue_pressed,
	yellow:yellow_pressed,
	purple:purple_pressed
}

var potion_size: int = 50
var rows: int = 9
var columns: int = 9
var x_offset = 20
var y_offset = 0

var potion_grid:Array =[]

var first_click_data:Dictionary
var second_click_data:Dictionary

var on_first: bool = true

var matched_potions:Array = []

var stable_potions:int =0

var total_points:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("potion_clicked", update_clicked_potion)
	SignalBus.connect("grid_update", update_grid)
	SignalBus.connect("spawn_new_potion", spawn_new_potion)
	for i in rows:
		potion_grid.append({})
	create_grid()
	create_appliers()
	create_spawners()
	add_child(new_disabler)
	
	#print(gem_grid)

func update_input_disabler():
	new_disabler.move_to_front()

func spawn_new_potion(id:int):
	possible_potions = [red, green, blue, yellow, purple]
	var potion_texture = possible_potions[randi_range(0,possible_potions.size()-1)]
	
	var new_potion = potion.instantiate()
	new_potion.position = Vector2(id*potion_size+x_offset, -potion_size) 
	new_potion.potion_data = {
		"id":"0"+str(id),
		"normal_texture": potion_texture,
		"pressed_texture":pressed_textures[potion_texture]
	}
	new_potion.button.texture_normal = potion_texture
	new_potion.button.texture_pressed = pressed_textures[potion_texture]
	call_deferred("add_child", new_potion)
	new_disabler.move_to_front()


func create_spawners():
	for i in columns:
		var new_spawner = spawner.instantiate()
		@warning_ignore("integer_division")
		new_spawner.position = Vector2(i*potion_size+x_offset+potion_size/2, -potion_size/2) 
		new_spawner.id = i
		add_child(new_spawner)

func create_appliers():
	for i in columns:
		for j in rows:
			var new_applier = applier.instantiate()
			@warning_ignore("integer_division")
			new_applier.position.x =i*potion_size+x_offset+potion_size/2
			@warning_ignore("integer_division")
			new_applier.position.y = j*potion_size+y_offset+potion_size/2
			new_applier.id = str(j)+str(i)
			add_child(new_applier)

func create_grid():
	for i in columns:
		for j in rows:
			possible_potions = [red, green, blue, yellow, purple]
			var new_potion = potion.instantiate()
			var potion_texture:CompressedTexture2D 
			if j<2:
				if i>1:
					begin_check_horiz(i,j)
			else:
				if i>1:
					begin_check_horiz(i,j)
				begin_check_vert(i,j)
			potion_texture = possible_potions[randi_range(0,possible_potions.size()-1)]
			potion_grid[j][str(j)+str(i)] = new_potion
			add_child(new_potion)
			new_potion.position.x =i*potion_size+x_offset
			new_potion.position.y = j*potion_size+y_offset
			new_potion.button.texture_normal = potion_texture
			new_potion.button.texture_pressed = pressed_textures[potion_texture]
			new_potion.potion_data["normal_texture"] = potion_texture
			new_potion.potion_data["pressed_texture"] = pressed_textures[potion_texture]
			new_potion.potion_data["id"] = str(j)+str(i)


func begin_check_horiz(i: int, j: int):
	var h_potion = potion_grid[j][str(j)+str(i-2)].button.texture_normal
	if h_potion == potion_grid[j][str(j)+str(i-1)].button.texture_normal:
		possible_potions.erase(h_potion)

func begin_check_vert(i: int, j: int):
	var v_potion = potion_grid[j-2][str(j-2)+str(i)].button.texture_normal
	if v_potion==potion_grid[j-1][str(j-1)+str(i)].button.texture_normal:
		possible_potions.erase(v_potion)

func update_clicked_potion(data):
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
			remove_matched_potions(matched_potions)
			matched_potions.clear()
		on_first = true
		untoggle()
		

func check_if_neighbors()->bool:
	var first = int(first_click_data["id"])
	var second = int(second_click_data["id"])
	if first == second-10 || first== second+10 || first== second-1 || first == second+1:
		return true
	return false

func untoggle():
	potion_grid[int(first_click_data["id"][0])][first_click_data["id"]].get_child(1).button_pressed = false
	potion_grid[int(second_click_data["id"][0])][second_click_data["id"]].get_child(1).button_pressed = false

func swap():
	potion_grid[int(second_click_data["id"][0])][second_click_data["id"]].swap(first_click_data)
	potion_grid[int(first_click_data["id"][0])][first_click_data["id"]].swap(second_click_data)

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
	matched_potions = remove_duplicates(matched_potions)


func check_horiz(i:int,j:int):
	if i>1:
		if i<9&&j<9:
			var h_potion = potion_grid[j][str(j)+str(i-2)].button.texture_normal
			if h_potion == potion_grid[j][str(j)+str(i-1)].button.texture_normal && h_potion==potion_grid[j][str(j)+str(i)].button.texture_normal:
				#print("H COMBO")
				matched_potions.append(str(j)+str(i))
				matched_potions.append(str(j)+str(i-1))
				matched_potions.append(str(j)+str(i-2))



func check_vert(i:int, j:int):
	if j>1:
		if i<9&&j<9:
			var v_potion = potion_grid[j-2][str(j-2)+str(i)].button.texture_normal
			if v_potion==potion_grid[j-1][str(j-1)+str(i)].button.texture_normal && v_potion == potion_grid[j][str(j)+str(i)].button.texture_normal:
				#print("V COMBO")
				matched_potions.append(str(j)+str(i))
				matched_potions.append(str(j-1)+str(i))
				matched_potions.append(str(j-2)+str(i))

func remove_duplicates(with_duplicates:Array)->Array:
	var no_duplicates = []
	for i in with_duplicates:
		if i not in no_duplicates:
			no_duplicates.append(i)
	return no_duplicates

func remove_matched_potions(potions:Array):
	for i in potions:
		potion_grid[int(i[0])][i].die()
	total_points+= potions.size()*10
	label.text = str(total_points)
	


func update_grid(id:String, body:Node):
	potion_grid[int(id[0])][id]=body


func check_grid():
	for i in columns:
		for j in rows:
			potion_grid[j][str(j)+str(i)].get_child(1).mouse_filter = 0
			check_vert(i,j)
			check_horiz(i,j)


func _on_falling_checker_body_entered(body: Node2D) -> void:
	if body.is_in_group("Potion"):
		stable_potions+=1
		falling_timer.stop()
		if stable_potions==9:
			falling_timer.start(.25)


func _on_falling_checker_body_exited(body: Node2D) -> void:
	if body.is_in_group("Potion"):
		#print("cool")
		stable_potions-=1
		if new_disabler.mouse_filter==2:
			new_disabler.mouse_filter = 0
		falling_timer.stop()

func _on_timer_timeout() -> void:
	check_grid()
	new_disabler.mouse_filter = 2
	remove_matched_potions(matched_potions)
	matched_potions.clear()
	falling_timer.stop()
