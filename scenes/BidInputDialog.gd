extends Control

onready var number_buttons = [
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/zero,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/one,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/two,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/three,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/four,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/five,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/six,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/seven,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/eight,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/nine,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/ten,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/eleven,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/twelve,
	$CenterContainer/PanelContainer/VBoxContainer/GridContainer/thirteen,
]

onready var pass_button = $CenterContainer/PanelContainer/VBoxContainer/PassButton/Button

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
