extends MarginContainer

onready var label = $PanelContainer/MarginContainer/Label

func set_text(text):
	label.text = text

func _ready():
	call_deferred("transition")

func transition():
	yield(get_tree().create_timer(2.0), "timeout")
	free()