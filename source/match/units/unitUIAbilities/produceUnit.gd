extends unitAbilities
class_name produceUnit

#"res://source/match/units/Unit.gd"
@export var toBeProduced : PackedScene

func getTooltipSource():
	tooltip_Scene = toBeProduced
	if tooltip_Scene:
		return tooltip_Scene.resource_path
	else:
		return tooltip_Alternativ

func Action(unit,units):
	unit.production_queue.produce(toBeProduced)
