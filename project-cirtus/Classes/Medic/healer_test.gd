## dw abt these "extend", i was just testing

#extends Control
#extends Node2D
extends CanvasLayer

## temporary labels used to print out scoring and stuff on screen
@export var label:Label
@export var label2:Label

## Falling Timer is used to check when the no potions are moving.
@export var falling_timer:Timer
## Game Timer determines how long the player has to play the minigame
@export var game_timer:Timer

## These are going to be instantiated later
@onready var potion = preload("res://Classes/Medic/potion_item.tscn")
var applier = preload("res://Classes/Medic/id_applier_area.tscn")
var spawner = preload("res://Classes/Medic/potion_spawner.tscn")
## In this case I just instantiated it now bc I only needed to do it once
## Also, it is used to disable input between games and also while the game is still calculating data
var input_disabler = preload("res://Classes/Medic/input_disabler.tscn")
var new_disabler = input_disabler.instantiate()

## Preloads of all the different textures
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

## These are the possible potions that can be created
var possible_potions:Array = [red, green, blue, yellow, purple]

## This is a dictionary giving out pressed textures determined by the normal texture
var pressed_textures:Dictionary= {
	red: red_pressed,
	green:green_pressed,
	blue:blue_pressed,
	yellow:yellow_pressed,
	purple:purple_pressed
}

## These are used to format the sizing of the grid
var potion_size: int = 50
var rows: int = 9
var columns: int = 9
var x_offset = 20
var y_offset = 0

## Will be used to form a 2d Array/Dictionary with all the instantiated potions and their corresponding ID
var potion_grid:Array =[]

## These are used to carry data from each time you click a potion
var first_click_data:Dictionary
var second_click_data:Dictionary

## Determines whether this is your first of second click
var on_first: bool = true

## An array with all the IDs of the potions that are matched
var matched_potions:Array = []

## The number of potions that are loaded at the top and also stable/not moving
var stable_potions:int =0

## The points for each potion color. Used to add and retrieve point data
var potion_points:Dictionary={
	red:0,
	green:0,
	blue:0,
	yellow:0,
	purple:0
}

## just used to convert between String color names and the actual texture
var name_to_texture:Dictionary ={
	"red":red,
	"green":green,
	"blue":blue,
	"yellow":yellow,
	"purple":purple,
}

## Given a value based on the color chosen by the player
var desired_color: String = ""
## Determines when the game has started or not
var game_started:bool = false

## Determines how effective the action is going to be after playing the minigame. 
var effect_multiplier:float

## Stores what the current mode is. Based off what is selected
enum Mode{HIGHSCORE, SELECTION}
var current_mode = Mode.HIGHSCORE

## sets up the overall game
func _ready() -> void:
	## All the conected global signals
	SignalBus.connect("potion_clicked", update_clicked_potion)
	SignalBus.connect("grid_update", update_grid)
	SignalBus.connect("spawn_new_potion", spawn_new_potion)
	SignalBus.connect("color_picked", color_picked)
	## Adds a certain number of dictionarys depending on the nnumber of rows there are
	for i in rows:
		potion_grid.append({})
	## creates all the needed elements, the potions, the spawners, the appliers and the input_disabler
	create_grid()
	create_appliers()
	create_spawners()
	add_child(new_disabler)
	update_input_disabler()
	new_disabler.mouse_filter = 0
	#print(gem_grid)

## brings the input_disabler to the front
func update_input_disabler():
	new_disabler.move_to_front()

## Spawns a new potion at the top of a column based on the ID. so an ID of 0 spawns something at column 0 (the first column)
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

## Creates all the potion spawners and places them at the top
func create_spawners():
	for i in columns:
		var new_spawner = spawner.instantiate()
		@warning_ignore("integer_division")
		new_spawner.position = Vector2(i*potion_size+x_offset+potion_size/2, -potion_size/2) 
		new_spawner.id = i
		add_child(new_spawner)

## Creates all the id appliers. Places them on each grid space
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

## creates all the potions and places them in a grid format. Gives each potion its texture and data. Also puts all the potions in the potion_grid array
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

## Checks if the 2 gems to the left of it are the same. If they are, remove their texture from possible_potions. Used in create_grid.
func begin_check_horiz(i: int, j: int):
	var h_potion = potion_grid[j][str(j)+str(i-2)].button.texture_normal
	if h_potion == potion_grid[j][str(j)+str(i-1)].button.texture_normal:
		possible_potions.erase(h_potion)

## Checks if the 2 gems above it are the same. If they are, remove their texture from possible_potions. Used in create_grid.
func begin_check_vert(i: int, j: int):
	var v_potion = potion_grid[j-2][str(j-2)+str(i)].button.texture_normal
	if v_potion==potion_grid[j-1][str(j-1)+str(i)].button.texture_normal:
		possible_potions.erase(v_potion)

## Sends and retrieves data from the clicked potions.
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
		## Checks if the two clicked potions are neighbors, if they are do a bunch of other checking. If not, reset.
		if check_if_neighbors():
			swap()
			check_for_combos()
			remove_matched_potions(matched_potions)
			matched_potions.clear()
		on_first = true
		untoggle()

## Checks if two IDs are neighbors using math. Returns true or false depending on whether they are or not.
func check_if_neighbors()->bool:
	var first = int(first_click_data["id"])
	var second = int(second_click_data["id"])
	if first == second-10 || first== second+10 || first== second-1 || first == second+1:
		return true
	return false

## Untoggles the neighbors that were pressed
func untoggle():
	potion_grid[int(first_click_data["id"][0])][first_click_data["id"]].get_child(1).button_pressed = false
	potion_grid[int(second_click_data["id"][0])][second_click_data["id"]].get_child(1).button_pressed = false

## Swaps the data of the two clicked potions
func swap():
	potion_grid[int(second_click_data["id"][0])][second_click_data["id"]].swap(first_click_data)
	potion_grid[int(first_click_data["id"][0])][first_click_data["id"]].swap(second_click_data)

## Checks for combos around the swapped potions
## Pattern:
## 
##  _ _ _
## |
## |
## |
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


## Checks if there are three in a rows horizontally
func check_horiz(i:int,j:int):
	if i>1:
		if i<9&&j<9:
			var h_potion = potion_grid[j][str(j)+str(i-2)].button.texture_normal
			if h_potion == potion_grid[j][str(j)+str(i-1)].button.texture_normal && h_potion==potion_grid[j][str(j)+str(i)].button.texture_normal:
				#print("H COMBO")
				matched_potions.append(str(j)+str(i))
				matched_potions.append(str(j)+str(i-1))
				matched_potions.append(str(j)+str(i-2))

## Checks if there are three in a rows verticcally
func check_vert(i:int, j:int):
	if j>1:
		if i<9&&j<9:
			var v_potion = potion_grid[j-2][str(j-2)+str(i)].button.texture_normal
			if v_potion==potion_grid[j-1][str(j-1)+str(i)].button.texture_normal && v_potion == potion_grid[j][str(j)+str(i)].button.texture_normal:
				#print("V COMBO")
				matched_potions.append(str(j)+str(i))
				matched_potions.append(str(j-1)+str(i))
				matched_potions.append(str(j-2)+str(i))

## Gets a array full of duplicates, removes them and returns back the new array
func remove_duplicates(with_duplicates:Array)->Array:
	var no_duplicates = []
	for i in with_duplicates:
		if i not in no_duplicates:
			no_duplicates.append(i)
	return no_duplicates

## removes the matched potions and adds points to their corresponding color
func remove_matched_potions(potions:Array):
	for i in potions:
		potion_points[potion_grid[int(i[0])][i].get_child(1).texture_normal] +=1
		potion_grid[int(i[0])][i].die()
	#print(potion_points)
	label.text = "Red Points: " + str(potion_points[red])+ "
	Green Points: " + str(potion_points[green])+ "
	Blue Points: " + str(potion_points[blue])+ "
	Yellow Points: " + str(potion_points[yellow])+ "
	Purple Points: " + str(potion_points[purple])

## Finds the data corresponding with the ID and replaces it with the new Data
func update_grid(id:String, new_potion:Node):
	potion_grid[int(id[0])][id]=new_potion

## Used to check for any more combos after the initial match
func check_grid():
	for i in columns:
		for j in rows:
			potion_grid[j][str(j)+str(i)].get_child(1).mouse_filter = 0
			check_vert(i,j)
			check_horiz(i,j)

##  adds to the counter for the number of loaded potions at the top
func _on_falling_checker_body_entered(body: Node2D) -> void:
	if body.is_in_group("Potion"):
		stable_potions+=1
		falling_timer.stop()
		if stable_potions==9:
			falling_timer.start(.25)

## subtracts to the counter for the number of loaded potions at the top
func _on_falling_checker_body_exited(body: Node2D) -> void:
	if body.is_in_group("Potion"):
		stable_potions-=1
		if new_disabler.mouse_filter==2:
			new_disabler.mouse_filter = 0
		falling_timer.stop()

## If this goes out, this means there are no more falling potions, 
## all the potions at the top are loaded and the game is ready to check again
func _on_timer_timeout() -> void:
	check_grid()
	if game_started:
		new_disabler.mouse_filter = 2
	remove_matched_potions(matched_potions)
	matched_potions.clear()
	falling_timer.stop()

## Occurs when a color is chosen. Starts the actual minigame
## Determines what mode the game should be in depending on the color chosen
func color_picked(color:String):
	if !game_started:
		game_started = true
		desired_color = color
		if desired_color == "random":
			current_mode = Mode.HIGHSCORE
		else:
			current_mode = Mode.SELECTION
		start_game()
		#print(color)

## Ends the game and makes sure players can't input any more matches
func end_game():
	if current_mode == Mode.SELECTION:
		effect_multiplier = get_effect_multiplier(potion_points[name_to_texture[desired_color]])
	elif current_mode == Mode.HIGHSCORE:
		var highest_color = find_highest_color()
		desired_color = name_to_texture.find_key(highest_color)
		effect_multiplier = get_effect_multiplier(potion_points[highest_color])
	update_input_disabler()
	new_disabler.mouse_filter = 0
	print(desired_color)
	print(effect_multiplier)
	label2.text = desired_color + ": " +str(effect_multiplier)
	game_started = false

## Starts the game timer, resets the scores and allows the player to input matches again.
func start_game():
	new_disabler.mouse_filter = 2
	game_timer.start()
	potion_points[red]=0
	potion_points[green]=0
	potion_points[blue]=0
	potion_points[yellow]=0
	potion_points[purple]=0
	label.text = "Red Points: " + str(potion_points[red])+ "
	Green Points: " + str(potion_points[green])+ "
	Blue Points: " + str(potion_points[blue])+ "
	Yellow Points: " + str(potion_points[yellow])+ "
	Purple Points: " + str(potion_points[purple])
	

## finds the color with the highest points and returns that color texture
func find_highest_color() -> CompressedTexture2D:
	var max = red
	for key in potion_points:
		if potion_points[key]>potion_points[max]:
			max = key
	return max

## calculates the effect multiplier based on the score gained. 
## its a piecewise function
func get_effect_multiplier(points:int):
	if points<=15:
		return float(points)/15
	if points>15:
		return 1.0+(points-15.0)*.5

## ends the game when the game timer ends
func _on_game_timer_timeout() -> void:
	end_game()
