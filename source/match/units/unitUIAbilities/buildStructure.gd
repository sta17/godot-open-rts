extends unitAbilities
class_name buildStructure

#"res://source/match/units/Unit.gd"
@export var toBeBuilt : PackedScene

func getTooltipSource():
	tooltip_Scene = toBeBuilt
	if tooltip_Scene:
		return tooltip_Scene.resource_path
	else:
		return tooltip_Alternativ

func Action(unit,units):
	MatchSignals.place_structure.emit(toBeBuilt)
