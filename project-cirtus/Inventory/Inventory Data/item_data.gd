extends Resource
class_name ItemData

#This script is basically going to be used for individual items

@export var item_name : String = ""
@export_multiline var item_description : String = ""
@export var is_item_stackable : bool = false
@export var item_texture : AtlasTexture

func use(target)-> void:
	pass
