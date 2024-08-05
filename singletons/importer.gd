extends Node


func import_jsonl(file_path: String) -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var data_array = []

	if file:
		while not file.eof_reached():
			var line = file.get_line()
			if line != "":
				var json = JSON.new()
				var json_data = json.parse(line)
				if json_data == OK:
					data_array.append(json.data)
				else:
					push_error("Error parsing JSON: %s" % json_data.error_string)
		file.close()
	else:
		push_error("Error opening file: %s" % file_path)

	return data_array
