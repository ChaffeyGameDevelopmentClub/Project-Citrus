extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_wizardchar_pressed() -> void:
	Global.character = "wizard"
	get_tree().change_scene_to_file("res://test_stage2iris.tscn")


func _on_medicchar_pressed() -> void:
	Global.character = "medic"
	get_tree().change_scene_to_file("res://test_stage2iris.tscn")


func _on_tankchar_pressed() -> void:
	Global.character = "tank"
	get_tree().change_scene_to_file("res://test_stage2iris.tscn")


func _on_warriorchar_pressed() -> void:
	Global.character = "warrior"
	get_tree().change_scene_to_file("res://test_stage2iris.tscn")
