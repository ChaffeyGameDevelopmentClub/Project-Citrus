extends CanvasLayer

@export var bar:TextureProgressBar
@export var label: Label

var attacking:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if attacking:
		bar.value += 300*delta
		if bar.value == 1000:
			attack()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("J"):
		bar.value = 0
		attacking = !attacking


func attack():
	bar.value =0
	label.text = "I Attacked"
	await get_tree().create_timer(1).timeout
	label.text = ""
