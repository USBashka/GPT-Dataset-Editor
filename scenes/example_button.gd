extends Button


@onready var examples_list = get_parent()


func _pressed() -> void:
	examples_list.select_example(get_index())


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			examples_list.remove_example_request(get_index())
