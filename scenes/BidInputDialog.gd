extends Control

onready var number_buttons = [
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/zero,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/one,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/two,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/three,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/four,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/five,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/six,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/seven,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/eight,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/nine,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/ten,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/eleven,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/twelve,
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer/thirteen,
]

onready var pass_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/PassButton/Button

signal button_pressed

func disable_pass():
	pass_button.disabled = true

func disable_range(start, stop):
	for i in range(number_buttons.size()):
		if start <= i and i <= stop:
			number_buttons[i].disabled = true

func _ready():
	for b in number_buttons:
		b.connect("pressed", self, "on_pressed", [b])
	pass_button.connect("pressed", self, "on_pressed", [pass_button])

func on_pressed(b):
	emit_signal("button_pressed", b.text)
