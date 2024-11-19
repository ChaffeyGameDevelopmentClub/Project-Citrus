extends CanvasLayer

@export var label: Label
@export var timer: Timer

var moves: Array = ["J", "K", "L"]
var player_moves: Array = []
var challenge_moves: Array = []
var label_text:String

var can_attack: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_attack:
		if Input.is_action_just_pressed("J"):
			player_moves.append("J")
		if Input.is_action_just_pressed("K"):
			player_moves.append("K")
		if Input.is_action_just_pressed("L"):
			player_moves.append("L")
		if player_moves.size() == challenge_moves.size():
			print(get_array_similarity())
			can_attack = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		start_attack()

func start_attack():
	player_moves = []
	challenge_moves = randomize_moves()
	label_text = get_string(challenge_moves)
	print(label_text)
	label.text = label_text
	can_attack = true
	timer.start(5)
	

func randomize_moves() -> Array:
	var temp:Array = []
	for i in moves:
		temp.append(moves[randi_range(0,moves.size()-1)])
	return temp

func get_string(moves) ->String:
	var temp_string : String = ""
	for i in moves:
		temp_string += i + "  "
	return temp_string

func get_array_similarity() -> int:
	var value = 0
	for i in challenge_moves.size():
		if player_moves[i]==challenge_moves[i]:
			value+=1
	return value

func _on_timer_timeout() -> void:
	can_attack = false
	print("You lose")
	timer.stop()
