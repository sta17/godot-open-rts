extends PanelContainer

var current_unit = null
var units = []

@onready var _unified_menu = find_child("Buttons")

@onready var _button_array = _unified_menu.get_children()

func _ready():
	_reset_menus()
	MatchSignals.unit_selected.connect(func(_unit): _reset_menus())
	MatchSignals.unit_deselected.connect(func(_unit): _reset_menus())
	MatchSignals.unit_died.connect(func(_unit): _reset_menus())


func _reset_menus():
	_hide_all_menus()
	if _try_showing_any_menu():
		show()
	else:
		hide()


func _hide_all_menus():
	_unified_menu.hide()
	CleanUpButtons()


func _try_showing_any_menu():
	var selected_controlled_units = get_tree().get_nodes_in_group("selected_units").filter(
		func(unit): return unit.is_in_group("controlled_units")
	)
	if selected_controlled_units.size() > 0:
		current_unit = selected_controlled_units[0]
		units = selected_controlled_units
		SetUpButtons()
		_unified_menu.show()
		return true
	return false

func getTooltip(resource_path):
	var arrayCo = Constants.Match.Units.DEFAULT_TOOLTIP[resource_path]["content"]
	var arrayTr = Constants.Match.Units.DEFAULT_TOOLTIP[resource_path]["translate"]
	var arrayFixed = []
	
	var i = 0
	for booleanValue in arrayTr:
		if(booleanValue): arrayFixed.append(tr(arrayCo[i]))
		else: arrayFixed.append(arrayCo[i])
		i = i + 1
	
	return (Constants.Match.Units.DEFAULT_TOOLTIP[resource_path]["format"].format(arrayFixed))

func CleanUpButtons():
	var i: int = 0
	for array_button in _button_array:
		array_button.set_disabled(true)
		#array_button.hide()
		array_button.set_button_icon(null)
		array_button.tooltip_text = ""
		i += 1

func SetUpButtons():
	var i: int = 0
	for action in current_unit.unitAbilities:
		if action != null:
			_button_array[i].set_button_icon(action.icon)
			var resource = action.getTooltipSource()
			if resource:
				_button_array[i].tooltip_text = getTooltip(resource)
			_button_array[i].set_disabled(false)
			_button_array[i].show()
		i += 1


func _on_button_00_pressed() -> void:
	current_unit.unitAbilities[0].Action(current_unit,units)
func _on_button_01_pressed() -> void:
	current_unit.unitAbilities[1].Action(current_unit,units)
func _on_button_02_pressed() -> void:
	current_unit.unitAbilities[2].Action(current_unit,units)
func _on_button_03_pressed() -> void:
	current_unit.unitAbilities[3].Action(current_unit,units)

func _on_button_04_pressed() -> void:
	current_unit.unitAbilities[4].Action(current_unit,units)
func _on_button_05_pressed() -> void:
	current_unit.unitAbilities[5].Action(current_unit,units)
func _on_button_06_pressed() -> void:
	current_unit.unitAbilities[6].Action(current_unit,units)
func _on_button_07_pressed() -> void:
	current_unit.unitAbilities[7].Action(current_unit,units)

func _on_button_08_pressed() -> void:
	current_unit.unitAbilities[8].Action(current_unit,units)
func _on_button_09_pressed() -> void:
	current_unit.unitAbilities[9].Action(current_unit,units)
func _on_button_10_pressed() -> void:
	current_unit.unitAbilities[10].Action(current_unit,units)
func _on_button_11_pressed() -> void:
	current_unit.unitAbilities[11].Action(current_unit,units)


func _on_button_12_pressed() -> void:
	current_unit.unitAbilities[12].Action(current_unit,units)
func _on_button_13_pressed() -> void:
	current_unit.unitAbilities[13].Action(current_unit,units)
func _on_button_14_pressed() -> void:
	current_unit.unitAbilities[14].Action(current_unit,units)
func _on_button_15_pressed() -> void:
	current_unit.unitAbilities[15].Action(current_unit,units)
