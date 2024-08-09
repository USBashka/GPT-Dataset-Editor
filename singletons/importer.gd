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
					Notification.notify(tr("Error parsing JSON"))
		file.close()
	else:
		Notification.notify(tr("Error opening file"))

	return data_array
