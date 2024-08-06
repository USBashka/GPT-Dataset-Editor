extends PanelContainer


signal replace(from: String, to: String)

@onready var find: LineEdit = $VBoxContainer/GridContainer/Find
@onready var replace_to: LineEdit = $VBoxContainer/GridContainer/ReplaceTo


func _on_replace_button_pressed() -> void:
	replace.emit(find.text, replace_to.text)
	hide()
	find.clear()
	replace_to.clear()


func _on_cancel_button_pressed() -> void:
	hide()
