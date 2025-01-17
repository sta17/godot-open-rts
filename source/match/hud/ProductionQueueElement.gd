extends Button

var queue = null
var queue_element = null


func _ready():
	if queue == null or queue_element == null:
		return
	queue_element.changed.connect(_on_queue_element_changed)
	pressed.connect(func(): queue.cancel(queue_element))
	#text = queue_element.unit_prototype.resource_path[
	#	queue_element.unit_prototype.resource_path.rfind("/") + 1
	#]
	
	var default_properties = Constants.Match.Units.DEFAULT_PROPERTIES[
		queue_element.unit_prototype.resource_path]
	var iconpath = default_properties["icon"]
	if iconpath:
		var textureFile = load(iconpath)
		icon = textureFile
		text = ""
	
	find_child("Label").text = "{0}%".format([int(queue_element.progress() * 100.0)])


func _on_queue_element_changed():
	find_child("Label").text = "{0}%".format([int(queue_element.progress() * 100.0)])
