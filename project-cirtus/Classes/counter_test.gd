extends CanvasLayer


@export var good_area:Area2D
@export var player_area:Area2D

@export var label:Label

var can_move: bool = false

var winnable:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move:
		player_area.rotate(deg_to_rad(180*delta))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		start()
	if event.is_action_pressed("J"):
		if winnable:
			label.text = "You win"
		else:
			label.text = "You lose"
		stop()



func start():
	set_random_good_area()
	can_move = true

func set_random_good_area():
	var degrees = randi_range(0,360)
	good_area.rotation_degrees = degrees

func stop():
	can_move = false
	good_area.rotation_degrees = 0
	player_area.rotation_degrees = 0



func _on_good_area_area_entered(area: Area2D) -> void:
	if area.name == "Player Area":
		winnable = true


func _on_good_area_area_exited(area: Area2D) -> void:
	if area.name == "Player Area":
		winnable = false
