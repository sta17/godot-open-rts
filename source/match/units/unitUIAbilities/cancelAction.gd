extends unitAbilities
class_name cancelAction

#"res://source/match/units/Unit.gd"
const Structure = preload("res://source/match/units/Structure.gd")
@export var units = []

func getTooltipSource():
	if tooltip_Scene:
		return tooltip_Scene.resource_path
	else:
		return tooltip_Alternativ

func Action(unit,units_array):
	units = units_array
	if len(units) == 1 and units[0] is Structure and units[0].is_under_construction():
		units[0].cancel_construction()
		return
	for array_unit in units:
		array_unit.action = null
