extends PanelContainer

var party_id = null

signal submit_pressed
signal cancel_pressed

func _ready():
	$VBoxContainer/InputContainer/LineEdit.connect("text_changed", self, "on_text_changed")
	$VBoxContainer/SubmitContainer/Button.connect("pressed", self, "on_submit")
	$VBoxContainer/CancelContainer/Button.connect("pressed", self, "on_cancel")

func on_text_changed(text):
	party_id = text

func on_submit():
	emit_signal("submit_pressed")

func on_cancel():
	emit_signal("cancel_pressed")