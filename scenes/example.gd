extends VBoxContainer


const MESSAGE = preload("res://scenes/message.tscn")


@onready var chat: VBoxContainer = $Chat
@onready var add: Button = $MarginContainer/Add


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func populate_chat(messages: Array) -> void:
	for m in messages:
		var message = MESSAGE.instantiate()
		var role: OptionButton = message.get_node("MarginContainer/HBoxContainer/Role")
		var content: TextEdit = message.get_node("MarginContainer2/Content")
		match m.role:
			"system": role.select(0)
			"user": role.select(1)
			"assistant": role.select(2)
		content.text = m.content
		chat.add_child(message)

func clear_chat() -> void:
	for child in chat.get_children():
		child.queue_free()
