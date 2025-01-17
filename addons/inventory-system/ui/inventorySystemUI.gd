@icon("res://addons/inventory-system/icons/node_inventory_system_base.svg")
extends Control
class_name InventorySystemUI

## This script manages inventory system UI information
## Contains drag slot information, UI inventories and item drop area

var inventoryOpenStatus: bool = false

## Stores [InventoryHandler] information to connect all signals and callbacks
var inventory_handler : InventoryHandler

## SlotUI special that stores inventory transaction information
@onready var transaction_slot_ui : TransactionSlotUI = get_node(NodePath("TransactionSlotUI"))

## Player [InventoryUI], Typically the main usage inventory
@onready var player_inventory_ui : InventoryUI = get_node(NodePath("PlayerInventoryUI") )

## Loot [InventoryUI], Typically an inventory that has been opened
@onready var loot_inventory_ui : InventoryUI = get_node(NodePath("LootInventoryUI"))

## Hotbar [HotbarUI]
@onready var hotbar_ui : HotbarUI = get_node(NodePath("HotbarUI"))

## Control that identifies area where a transaction slot can call the handler to drop items
@onready var drop_area: Control = get_node(NodePath("DropArea"))

var current_unit = null
var units = []

func _ready():
	player_inventory_ui.visible = false
	loot_inventory_ui.visible = false
	transaction_slot_ui.clear_info()
	drop_area.visible = false
	hotbar_ui.visible = true
	player_inventory_ui.slot_point_down.connect(_slot_point_down.bind())
	player_inventory_ui.inventory_point_down.connect(_inventory_point_down.bind())
	loot_inventory_ui.slot_point_down.connect(_slot_point_down.bind())
	loot_inventory_ui.inventory_point_down.connect(_inventory_point_down.bind())
	#drop_area.gui_input.connect(_drop_area_input.bind())
	
	MatchSignals.unit_selected.connect(func(_unit): _reset_menus())
	MatchSignals.unit_deselected.connect(func(_unit): _reset_menus())
	MatchSignals.unit_died.connect(func(_unit): _reset_menus())

func _reset_menus():
	hide()
	if _try_showing_UI():
		show()
	else:
		hide()

#toggle_inventory

func _process(_delta):
#func _unhandled_input(event):
	
	#if (event.is_action_pressed("toggle_inventory") and !inventoryOpenStatus):
	if Input.is_action_just_released("toggle_inventory"):
		if inventory_handler.is_open_main_inventory():
			inventory_handler.close_main_inventory()
			inventory_handler.close_all_inventories()
		else:
			inventory_handler.open_main_inventory()
		
	#	_open_player_inventory()
	#	inventoryOpenStatus = true
	#else:
	#	_close_player_inventory()
	#	inventoryOpenStatus = false

func _try_showing_UI():
	var selected_controlled_units = get_tree().get_nodes_in_group("selected_units").filter(
		func(unit): return unit.is_in_group("controlled_units")
	)
	if selected_controlled_units.size() > 0:
		current_unit = selected_controlled_units[0]
		units = selected_controlled_units
		if "InventoryHandler" in current_unit:
			var local_inventory_handler = current_unit.InventoryHandler
			if local_inventory_handler:
				setup_inventory_handler(local_inventory_handler)
				return true
	return false

## Setup inventory handler and connect all signals
func set_player_inventory_handler(handler : InventoryHandler):
	inventory_handler = handler
	transaction_slot_ui.inventory_handler = handler
	set_player_inventory(handler.inventory)
	handler.opened.connect(_on_open_inventory)
	handler.closed.connect(_on_close_inventory)
	handler.updated_transaction_slot.connect(_updated_transaction_slot)


func set_hotbar(hotbar : Hotbar):
	hotbar_ui.set_hotbar(hotbar)


func setup_inventory_handler(handler : InventoryHandler):
	#inventory_handler = handler
	set_player_inventory_handler(handler)
	set_hotbar(handler.get_node("Hotbar"))
	#handler.opened.connect(_update_opened_inventories.bind())
	#handler.closed.connect(_update_opened_inventories.bind())
	#_update_opened_inventories(handler.inventory)

func _update_opened_inventories(_inventory : Inventory):
	if inventory_handler.is_open_main_inventory():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

## Setup player [Inventory]
func set_player_inventory(player_inventory : Inventory):
	player_inventory_ui.set_inventory(player_inventory)


func _drop_area_input(event : InputEvent):
	if event is InputEventMouseButton and inventory_handler:
		if event.pressed:
			inventory_handler.drop_transaction()


func _open_player_inventory():
	player_inventory_ui.visible = true
	hotbar_ui.visible = false
	drop_area.visible = true
	if not player_inventory_ui.slots.is_empty():
		player_inventory_ui.slots[0].grab_focus()


# Open Inventory of player	
func _on_open_inventory(inventory : Inventory):
	if inventory != inventory_handler.inventory:
		loot_inventory_ui.set_inventory(inventory)
		loot_inventory_ui.visible = true
	else:
		_open_player_inventory()


func _on_close_inventory(inventory : Inventory):
	if inventory == inventory_handler.inventory:
		_close_player_inventory()


func _close_player_inventory():
	player_inventory_ui.visible = false
	loot_inventory_ui.visible = false
	if loot_inventory_ui.inventory != null:
		loot_inventory_ui._disconnect_old_inventory()
#    hotbarContainer.gameObject.SetActive(false);
	drop_area.visible = false
	hotbar_ui.visible = true


func _slot_point_down(event : InputEvent, slot_index : int, inventory : Inventory):
	if inventory_handler.is_transaction_active():
		inventory_handler.transaction_to_at(slot_index, inventory)
		#$SlotDrop.play()
	else:
		if inventory.is_empty_slot(slot_index):
			return
		var slot = inventory.slots[slot_index]
		var amount = slot.amount
		if event is InputEventMouseButton and event.button_index == 2:
			amount = ceili(slot.amount/2.0)
		inventory_handler.to_transaction(slot_index, inventory, amount)	
		#$SlotClick.play()
		

func _inventory_point_down(event : InputEvent, inventory : Inventory):
	if event.button_index == 3:
		return
	if inventory_handler.is_transaction_active():
		inventory_handler.transaction_to(inventory)
		#$SlotDrop.play()


func _updated_transaction_slot(item : InventoryItem, amount : int):
	transaction_slot_ui.update_info_with_item(item, amount)
