extends VBoxContainer


@export var text_length: int = 24
@export var group := ButtonGroup.new()

const EXAMPLE_BUTTON = preload("res://scenes/example_button.tscn")

signal example_selected(index: int)


func populate_list(data: Array) -> void:
	var i: int
	for example in data:
		var button = EXAMPLE_BUTTON.instantiate()
		button.button_group = group
		button.text = example["messages"][1]["content"].replace("\n", " ")
		add_child(button)
		i += 1
	print(i)

func clear_list() -> void:
	for child in get_children():
		child.queue_free()

func select_example(index: int) -> void:
	example_selected.emit(index)
