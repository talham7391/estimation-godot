extends PanelContainer

var score_entry = preload("res://scenes/ScoreEntry.tscn")

onready var entries_container = $MarginContainer/VBoxContainer/VBoxContainer

func add_entry(name, score):
	var instance = score_entry.instance()
	instance.set_name(name)
	instance.set_score(score)
	entries_container.add_child(instance)
