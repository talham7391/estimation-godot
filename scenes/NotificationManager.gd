extends Control

var notification_scene = preload("res://scenes/Notification.tscn")

onready var notifications_container = $MarginContainer/VBoxContainer

func display_notification(message):
	var n = notification_scene.instance()
	notifications_container.add_child(n)
	n.set_text(message)
