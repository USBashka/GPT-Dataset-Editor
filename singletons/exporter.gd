extends Node


func export_jsonl(file_path: String, data: Array) -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		Notification.notify(tr("Error opening file"))
		return
	
	for item in data:
		var json_string = JSON.stringify(item, "", false)
		file.store_line(json_string)
	
	file.close()
	
	Notification.notify(tr("File saved"))
