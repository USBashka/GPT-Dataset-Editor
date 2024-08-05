extends Node


var s = {
	"language": "en",
	"theme": "dark",
	"background": "default",
	"fullscreen": false
}

var state = {
	"file": "untitled.jsonl",
	"example": 0
}

const CONFIG_FILE_PATH = "user://settings.cfg"


func _ready():
	load_settings()


func save_settings():
	var config_file = ConfigFile.new()
	for key in s.keys():
		config_file.set_value("settings", key, s[key])
	for key in state.keys():
		config_file.set_value("state", key, state[key])
	config_file.save(CONFIG_FILE_PATH)


func load_settings():
	var config_file = ConfigFile.new()
	var err = config_file.load(CONFIG_FILE_PATH)
	if err == OK:
		for key in s.keys():
			if config_file.has_section_key("settings", key):
				s[key] = config_file.get_value("settings", key)
		for key in state.keys():
			if config_file.has_section_key("state", key):
				state[key] = config_file.get_value("state", key)
