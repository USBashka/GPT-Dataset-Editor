extends Node


var s = {
	"language": "en",
	"theme": "dark",
	"background": "default",
	"fullscreen": false
}

const CONFIG_FILE_PATH = "user://settings.cfg"


func _ready():
	load_settings()


func save_settings():
	var config_file = ConfigFile.new()
	for key in s.keys():
		config_file.set_value("settings", key, s[key])
	config_file.save(CONFIG_FILE_PATH)


func load_settings():
	var config_file = ConfigFile.new()
	var err = config_file.load(CONFIG_FILE_PATH)
	if err == OK:
		for key in s.keys():
			if config_file.has_section_key("settings", key):
				s[key] = config_file.get_value("settings", key)
