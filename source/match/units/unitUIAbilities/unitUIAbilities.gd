@icon("res://assets/icons/pixel-boy/node_3D/icon_target_2.png")
extends Resource
class_name unitAbilities

func _to_string():
	var action_script_path = get_script().resource_path
	var action_file_name = action_script_path.substr(action_script_path.rfind("/") + 1)
	var action_name = action_file_name.split(".")[0]
	return action_name

@export var icon : Texture
@export var tooltip_Scene: PackedScene
@export var tooltip_Alternativ: String

func Action(unit,units):
	pass

func getTooltipSource():
	if tooltip_Scene:
		return tooltip_Scene.resource_path
	else:
		return tooltip_Alternativ
