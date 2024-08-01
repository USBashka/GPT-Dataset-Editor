extends Control


@onready var background: TextureRect = $Background
@onready var bg_color: ColorRect = $Background/ColorRect


@onready var file_menu: PopupMenu = $VBoxContainer/PanelContainer/HBoxContainer/MenuBar/File
@onready var settings: PopupMenu = $VBoxContainer/PanelContainer/HBoxContainer/MenuBar/Settings
@onready var help: PopupMenu = $VBoxContainer/PanelContainer/HBoxContainer/MenuBar/Help


var color_popup: Window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bg = Settings.s.background
	if bg != "default":
		if bg[0] == "#":
			bg_color.color = Color(bg)
		else:
			background.texture = load_image(bg)
	bind_shortcuts_to_menu(file_menu, 0, "file_new")
	bind_shortcuts_to_menu(file_menu, 1, "file_open")
	bind_shortcuts_to_menu(file_menu, 2, "file_save")
	bind_shortcuts_to_menu(file_menu, 3, "file_save_as")
	settings.add_submenu_item("Language", "Language")
	settings.add_submenu_item("Theme", "Theme")
	settings.add_submenu_item("Background", "Background")
	bind_shortcuts_to_menu(help, 0, "help")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN
		if !DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN 
		else DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_file_id_pressed(id: int) -> void:
	print(id)


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
			color_popup.size = Vector2(298, 580)
			var color_dialog = ColorPicker.new()
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
	bg_color.color = Color.TRANSPARENT

func _on_bg_color_selected(color: Color):
	bg_color.color = color
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
