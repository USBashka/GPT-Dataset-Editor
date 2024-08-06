extends VBoxContainer


signal example_selected(index: int)

const EXAMPLE_BUTTON = preload("res://scenes/example_button.tscn")

@export var text_length: int = 24
@export var group := ButtonGroup.new()


func populate_list(data: Array) -> void:
	for example in data:
		var button = EXAMPLE_BUTTON.instantiate()
		button.button_group = group
		button.text = example["messages"][1]["content"].replace("\n", " ")
		add_child(button)

func clear_list() -> void:
	for child in get_children():
		child.queue_free()

func select_example(index: int) -> void:
	example_selected.emit(index)

func remove_example_request(index: int) -> void:
	get_tree().current_scene.get_node("RemoveExampleDialog").popup_centered()

