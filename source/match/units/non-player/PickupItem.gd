@icon("res://assets/icons/pixel-boy/node_3D/icon_money_bag.png")
extends Area3D
class_name PickUpItem

@export var item : InventoryItem
@export var is_pickable := true
@export var amount : int
var toBeDeleted:bool = false
var radius:
	get: 
		return 0.6
var global_position_yless:
	get:
		return global_position * Vector3(1, 0, 1)

var color = Constants.Match.Items.Minimap.COLOR:
	set(_value):
		pass

func Collect(unit):
	if toBeDeleted:
		return
	toBeDeleted = true
	if "InventoryHandler" in unit:
			var local_inventory_handler = unit.InventoryHandler
			if local_inventory_handler:
				local_inventory_handler.pick_to_inventory(self)
	queue_free()
