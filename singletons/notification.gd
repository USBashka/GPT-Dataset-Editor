extends PanelContainer


signal notified

var is_notifying: bool = false

@onready var label: Label = $Label


func _ready():
	position.y += size.y


func notify(text: String, time: float = 2) -> void:
	if is_notifying:
		await notified
	is_notifying = true
	label.text = text
	var tween: Tween = create_tween()
	tween.tween_property(self, "position:y", position.y - size.y, 0.1)
	await get_tree().create_timer(time).timeout
	tween = create_tween()
	tween.tween_property(self, "position:y", position.y + size.y, 0.1)
	await tween.finished
	is_notifying = false
	notified.emit()
