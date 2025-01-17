extends "res://source/match/units/actions/Action.gd"

var _target_item = null
var collected:bool = false

@onready var _unit = Utils.NodeEx.find_parent_with_group(self, "units")


func _init(target_item):
	_target_item = target_item
	pass


func _ready():
	_target_item.tree_exited.connect(queue_free)
	_target_item.Collect(_unit)
	collected = true


func _process(delta):
	if collected:
		queue_free()
		return
	
	if (
		not _target_item
	):
		queue_free()
		return
