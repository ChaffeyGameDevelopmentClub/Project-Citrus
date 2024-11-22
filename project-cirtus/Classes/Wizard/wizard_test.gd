extends CanvasLayer
#extends Node2D
var rune = preload("res://Classes/Wizard/osu_button.tscn")

var red_texture = preload("res://test_sprites/30.png")
var blue_texture = preload("res://test_sprites/32.png")
var yellow_texture = preload("res://test_sprites/33.png")
var purple_texture = preload("res://test_sprites/34.png")


var rune_textures:Dictionary = {
	0:red_texture,
	1:blue_texture,
	2:yellow_texture,
	3:purple_texture
}

var rune_points:Dictionary = {
	0:0,
	1:0,
	2:0,
	3:0
}

var runes:Array =[0,1,2,3,4,5,6,7]

func _ready() -> void:
	SignalBus.connect("update_runes", update_runes)
	create_runes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_runes(rune_color):
	rune_points[rune_textures.find_key(rune_color)]+=1
	for i in range(4):
		runes[i+4] = runes[i]
		runes[i] = create_button(runes[i].global_position, rune_textures[i])
		runes[i+4].queue_free()
	print(rune_points)

func create_runes():
	for i in range(4):
		runes[i] = create_button(Vector2(576, 324), rune_textures[i])

func create_button(prev_position, texture):
	var new_rune = rune.instantiate()
	var direction = new_direction()
	new_rune.texture_normal = texture
	new_rune.texture_pressed = texture
	new_rune.rune_color = texture
	add_child(new_rune)
	direction = direction*randi_range(50, 200)
	new_rune.global_position = prev_position + direction
	if check_off_screen(new_rune.global_position):
		new_rune.global_position += -2*direction
	return new_rune

func check_off_screen(pos):
	if pos.y<=0 || pos.y>=648 ||pos.x<=0||pos.x>=1152:
		return true
	return false

func new_direction() -> Vector2:
	var degrees = randi_range(0,360)
	var new_direction = Vector2(cos(deg_to_rad(degrees)),sin(deg_to_rad(degrees)))
	return new_direction
