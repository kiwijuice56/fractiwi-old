extends Node
class_name FileSaver
# Handles saving game to file

export var path: String
export var default_path: String

func _ready() -> void:
	save_file(0)

func get_files() -> Array:
	var files := []
	for _i in range(99):
		files.append(null)
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "" or file == "save_file.gd":
			break
		elif not file.begins_with("."):
			files[int(file)] = file
	dir.list_dir_end()
	return files

func save_file(index: int) -> void:
	var file = File.new()
	file.open(path + "%02d" % index, File.WRITE)
	file.store_line(to_json(initialize_file(index)))
	for node in get_tree().get_nodes_in_group("Save"):
		var node_data = node.save_data()
		file.store_line(to_json(node_data))
	file.close()

func initialize_file(index: int) -> Dictionary:
	var file_data = {}
	file_data["id"] = index
	file_data["time"] = 0
	return file_data

func load_file(index: int) -> void:
	var file = File.new()
	if index == -1:
		file.open(default_path, File.READ)
	else:
		file.open(path + "%02d" % (index), File.READ)
	var save_node_index = 0
	var nodes = get_tree().get_nodes_in_group("Save")
	file.get_line() # ID line
	while true:
		var node_data = file.get_line()
		if node_data == "":
			break
		nodes[save_node_index].load_data(parse_json(node_data))
		save_node_index += 1
	file.close()
