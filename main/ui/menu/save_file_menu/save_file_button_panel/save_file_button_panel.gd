extends ButtonPanel
class_name SaveFileButtonPanel

export(NodePath) var location_label
export(NodePath) var empty_label
export(NodePath) var num_label
export(NodePath) var time_label

func _ready():
	location_label = get_node(location_label)
	empty_label = get_node(empty_label)
	num_label = get_node(num_label)
	time_label = get_node(time_label)

func initialize(file: SaveFile, index: int) -> void:
	var str_index = "%02d" % index
	if not file:
		empty_label.text = str_index + " EMPTY"
		$MarginContainer/VBoxContainer.visible = false
		$MarginContainer/EmptyLabel.visible = true
	else:
		num_label.text = str_index
		location_label.text = file.data["World"]["location"] + ":" + file.data["World"]["terminal"]
		set_time(file.data["FileSaver"]["time"])
		$MarginContainer/VBoxContainer.visible = true
		$MarginContainer/EmptyLabel.visible = false

func set_time(time: int) -> void:
	#warning-ignore:integer_division
	var hours = int(time/3600)
	var minutes = (time-(hours*3600))/60
	var seconds = time-(hours*3600)-(minutes*60)
	time_label.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
