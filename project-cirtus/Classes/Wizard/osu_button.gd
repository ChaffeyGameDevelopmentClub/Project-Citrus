extends TextureButton

var circle = preload("res://Classes/Wizard/osu_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_down() -> void:
	create_button()
	queue_free()

func create_button():
	var new_circle = circle.instantiate()
	var direction = new_direction()
	get_parent().add_child(new_circle)
	new_circle.global_position = global_position + direction*100
	

func new_direction() -> Vector2:
	var degrees = randi_range(0,360)
	var new_direction = Vector2(cos(deg_to_rad(degrees)),sin(deg_to_rad(degrees)))
	return new_direction
