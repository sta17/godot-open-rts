extends "res://source/match/units/actions/Action.gd"

#need something to define if the unit har inventory space for legal check
const InventoryUnit = preload("res://source/match/units/SpecialCharacter.gd")
const TempItem = preload("res://source/match/units/non-player/PickupItem.gd")
const MovingToUnit = preload("res://source/match/units/actions/MovingToUnit.gd")
const Moving = preload("res://source/match/units/actions/Moving.gd")
const CollectItem = preload("res://source/match/units/actions/CollectItem.gd")

var _target_item = null
var _sub_action = null

@onready var _unit = Utils.NodeEx.find_parent_with_group(self, "units")

#need something to define if the unit har inventory space
static func is_applicable(source_unit, target_item):
	return (
		source_unit is InventoryUnit and target_item is TempItem
	)


func _init(target_item):
	_target_item = target_item
	pass


func _ready():
	_collect_or_move_closer()

# Implement subAction Collect
func _collect_or_move_closer():
	if not Utils.Match.Unit.Movement._unit_in_range_of_other(_unit, _target_item, 0):
		_sub_action = MovingToUnit.new(_target_item)
		_sub_action.tree_exited.connect(_on_sub_action_finished)
	else:
		_sub_action = CollectItem.new(_target_item)
		_sub_action.tree_exited.connect(_on_target_item_collected)
	add_child(_sub_action)
	_unit.action_updated.emit()


func _to_string():
	return "{0}({1})".format([super(), str(_sub_action) if _sub_action != null else ""])


func _on_sub_action_finished():
	if not is_inside_tree():
		return
	if not is_instance_valid(_target_item) or not _target_item.is_inside_tree() or not _target_item or _target_item.toBeDeleted:
		queue_free()
		return
	_sub_action = null
	_collect_or_move_closer()

func _on_target_item_collected():
	if not is_inside_tree():
		return
	_sub_action.tree_exited.disconnect(_on_sub_action_finished)
	queue_free()
