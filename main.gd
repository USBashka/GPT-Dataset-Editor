extends Control


@onready var settings: PopupMenu = $VBoxContainer/PanelContainer/HBoxContainer/MenuBar/Settings


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings.add_submenu_item("Language", "Language")
	settings.add_submenu_item("Theme", "Theme")
	settings.add_submenu_item("Background", "Background")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_file_id_pressed(id: int) -> void:
	pass # Replace with function body.


func _on_settings_id_pressed(id: int) -> void:
	print(id)


func _on_help_id_pressed(id: int) -> void:
	match id:
		0: OS.shell_open("https://github.com/USBashka/GPT-Dataset-Editor")
		1: OS.shell_open("https://platform.openai.com/docs/guides/fine-tuning")
		2: OS.shell_open("https://platform.openai.com/finetune")
