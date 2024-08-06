extends Control


@onready var background: TextureRect = $Background
@onready var bg_color: ColorRect = $Background/ColorRect


@onready var file_menu: PopupMenu = $VBoxContainer/PanelContainer/HBoxContainer/MenuBar/File
@onready var settings: PopupMenu = $VBoxContainer/PanelContainer/HBoxContainer/MenuBar/Settings
@onready var help: PopupMenu = $VBoxContainer/PanelContainer/HBoxContainer/MenuBar/Help
@onready var file_name: Label = $VBoxContainer/PanelContainer/HBoxContainer/FileName

@onready var examples_list: VBoxContainer = $VBoxContainer/HSplitContainer/Left/VBoxContainer/ScrollContainer/ExamplesList

@onready var example: VBoxContainer = $VBoxContainer/HSplitContainer/Center/ScrollContainer/Example
@onready var replace_menu: PanelContainer = $ReplaceMenu


var color_popup: Window
var current_file: String = "untitled.jsonl"
var data: Array
var current_example = 0

const FILE_OPEN = preload("res://scenes/file_open.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().min_size = Vector2i(900, 600)
	var bg = Settings.s.background
	if bg != "default":
		if bg[0] == "#":
			bg_color.color = Color(bg)
			bg_color.show()
		else:
			background.texture = load_image(bg)
	bind_shortcuts_to_menu(file_menu, 0, "file_new")
	bind_shortcuts_to_menu(file_menu, 1, "file_open")
	bind_shortcuts_to_menu(file_menu, 2, "file_save")
	bind_shortcuts_to_menu(file_menu, 3, "file_save_as")
	settings.add_submenu_item(tr("Language"), "Language")
	settings.add_submenu_item(tr("Theme"), "Theme")
	settings.add_submenu_item(tr("Background"), "Background")
	bind_shortcuts_to_menu(help, 0, "help")
	
	if Settings.state.file != "untitled.jsonl":
		open_file(Settings.state.file)
		open_example(Settings.state.example)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN
		if !DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN 
		else DisplayServer.WINDOW_MODE_MAXIMIZED)
	elif event.is_action_pressed("next_example"):
		current_example +=1
		open_example(current_example)


func _on_file_id_pressed(id: int) -> void:
	match id:
		0: #New
			pass
		1: #Open
			var file_open = FILE_OPEN.instantiate()
			file_open.file_selected.connect(_on_file_open)
			file_open.popup()
		2: #Save
			Exporter.export_jsonl(current_file, data)

func _on_file_open(file: String) -> void:
	open_file(file)
	open_example(current_example)


func _on_settings_id_pressed(id: int) -> void:
	print(id)


func _on_help_id_pressed(id: int) -> void:
	match id:
		0: OS.shell_open("https://github.com/USBashka/GPT-Dataset-Editor")
		1: OS.shell_open("https://platform.openai.com/docs/guides/fine-tuning")
		2: OS.shell_open("https://platform.openai.com/finetune")


func _on_language_id_pressed(id: int) -> void:
	pass # Replace with function body.


func _on_theme_id_pressed(id: int) -> void:
	pass # Replace with function body.


func _on_background_id_pressed(id: int) -> void:
	match id:
		0: #From image
			var file_dialog = FileDialog.new()
			file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
			file_dialog.filters = ["*.png, *.jpg, *.jpeg, *.webp"]
			file_dialog.access = FileDialog.ACCESS_FILESYSTEM
			file_dialog.title = tr("Select background image")
			file_dialog.min_size = Vector2(600, 400)
			file_dialog.file_selected.connect(_on_bg_image_selected)
			file_dialog.use_native_dialog = true
			add_child(file_dialog)
			file_dialog.popup_centered()
		1: #From color
			color_popup = Window.new()
			color_popup.close_requested.connect(_on_bg_color_close)
			color_popup.title = tr("Select background color")
			color_popup.min_size = Vector2(298, 580)
			var color_dialog = ColorPicker.new()
			color_dialog.color = bg_color.color
			color_dialog.color_changed.connect(_on_bg_color_selected)
			color_popup.add_child(color_dialog)
			add_child(color_popup)
			color_popup.popup_centered()
		2: #Default
			background.texture = load("res://assets/pexels-stywo-1261728.jpg")
			bg_color.color = Color.TRANSPARENT
			Settings.s.background = "default"
			Settings.save_settings()

func _on_bg_image_selected(image: String):
	background.texture = load_image(image)
	Settings.s.background = image
	Settings.save_settings()
	bg_color.hide()

func _on_bg_color_selected(color: Color):
	bg_color.color = color
	bg_color.show()
	Settings.s.background = "#" + color.to_html()
	Settings.save_settings()

func _on_bg_color_close():
	color_popup.queue_free()


func bind_shortcuts_to_menu(menu: PopupMenu, index: int, action: String):
	var shortcut = Shortcut.new()
	var events = InputMap.action_get_events(action)
	if events:
		shortcut.events.append(events[0])
		menu.set_item_shortcut(index, shortcut)

func load_image(path: String) -> Texture:
	var img = Image.new()
	if img.load(path) == OK:
		var texture = ImageTexture.new()
		texture.set_image(img)
		return texture
	else:
		print("Failed to load image: ", path)
		return null


func open_file(file: String) -> void:
	file_name.text = file
	current_file = file
	data = Importer.import_jsonl(file)
	current_example = 0
	examples_list.populate_list(data)
	Settings.state.file = file
	Settings.save_settings()


func open_example(index: int) -> void:
	example.clear_chat()
	example.populate_chat(data[index]["messages"])
	Settings.state.example = index
	Settings.save_settings()


func _on_new_example_pressed() -> void:
	print("SOS")


func _on_examples_list_example_selected(index: int) -> void:
	current_example = index
	open_example(current_example)


func _on_tools_id_pressed(id: int) -> void:
	match id:
		0: #Find
			pass
		1: #Replace
			replace_menu.show()


func _on_replace_menu_replace(from: String, to: String) -> void:
	Tools.replace(data, from, to)
