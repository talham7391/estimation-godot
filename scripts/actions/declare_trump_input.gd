extends Node

var trump_input_dialog = preload("res://scenes/TrumpInputDialog.tscn")
var trump_input_dialog_instance = null

func _ready():
	trump_input_dialog_instance = trump_input_dialog.instance()
	trump_input_dialog_instance.connect("trump_chosen", self, "on_trump_chosen")
	add_child(trump_input_dialog_instance)

func on_trump_chosen(suit):
	trump_input_dialog_instance.call_deferred("free")
	trump_input_dialog_instance = null
	client.send_obj_to_server({"type": "DECLARE_TRUMP", "suit": suit})
