extends "res://source/match/units/Unit.gd"

const WaitingForTargets = preload("res://source/match/units/actions/WaitingForTargets.gd")

## Main [InventoryHandler] node.
@export_node_path("InventoryHandler") var InventoryHandler_path := NodePath("InventoryHandler")
@onready var InventoryHandler := get_node(InventoryHandler_path)


func _ready():
	await super()
	action_changed.connect(_on_action_changed)
	action = WaitingForTargets.new()


func _on_action_changed(new_action):
	if new_action == null:
		action = WaitingForTargets.new()
