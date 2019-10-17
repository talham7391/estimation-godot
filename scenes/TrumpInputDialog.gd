extends Control

onready var buttons = [
	$CenterContainer/PanelContainer/VBoxContainer/Diamonds/Button,
	$CenterContainer/PanelContainer/VBoxContainer/Spades/Button,
	$CenterContainer/PanelContainer/VBoxContainer/Hearts/Button,
	$CenterContainer/PanelContainer/VBoxContainer/Clubs/Button,
]

signal trump_chosen

func _ready():
	for b in buttons:
		b.connect("pressed", self, "on_pressed", [b])

func on_pressed(b):
	emit_signal("trump_chosen", b.text)