extends Area3D

@export var timeline: String

var can_interact: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact")&& can_interact:
		Dialogic.start(timeline)

func _on_area_entered(area: Area3D) -> void:
	can_interact = true


func _on_area_exited(area: Area3D) -> void:
	can_interact = false
