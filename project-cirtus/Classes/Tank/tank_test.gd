extends CanvasLayer

@export var attack_bar: TextureProgressBar
@export var label:Label

var moves: Array = ["J", "K", "L"]
var attack_charging: bool = false

var min_bar: int = 0
var max_bar:int = 0

var current_move: String = "J"
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if attack_charging:
		attack_bar.value -= delta*40
		attack_bar.value = max(min_bar,attack_bar.value)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		start()
	if event.is_action_pressed(current_move)&&attack_charging:
		attack_bar.value +=20
		if attack_bar.value>=max_bar:
			change_move()
			print(max_bar)

func start():
	current_move = moves[randi_range(0,moves.size()-1)]
	min_bar = 0
	max_bar = 100
	label.text = current_move
	attack_charging = true

func change_move():
	current_move = moves[randi_range(0,moves.size()-1)]
	min_bar+=100
	max_bar+=100
	label.text = current_move
	if max_bar>attack_bar.max_value:
		stop()

func stop():
	attack_charging= false
	attack_bar.value = 0
	min_bar = 0
	max_bar = 100
	label.text = ""
