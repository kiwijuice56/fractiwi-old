extends Node
class_name FileSaver
# Handles saving game to file

export var path: String

func _ready() -> void:
	save_file(0)
	save_file(98)

func get_files() -> Array:
	var files := []
	for i in range(99):
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
	print(files)
	return files

func save_file(index: int) -> void:
	var file = File.new()
	file.open(path + "%02d" % index, File.WRITE)
	file.store_line(to_json(initialize_file()))
	for node in get_tree().get_nodes_in_group("Save"):
		var node_data = node.save_data()
		file.store_line(to_json(node_data))
	file.close()

func initialize_file() -> Dictionary:
	var id = {}
	id["id"] = 0
	return id

func load_file(index: int) -> void:
	pass
