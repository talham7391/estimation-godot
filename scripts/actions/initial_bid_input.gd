extends Node

var initial_bid_dialog = preload("res://scenes/BidInputDialog.tscn")
var initial_big_dialog_instance = null

func _ready():
	initial_big_dialog_instance = initial_bid_dialog.instance()
	initial_big_dialog_instance.connect("button_pressed", self, "on_button_pressed")
	add_child(initial_big_dialog_instance)
	if should_disable_pass():
		initial_big_dialog_instance.disable_pass()
	initial_big_dialog_instance.disable_range(-1, get_highest_bid())

func should_disable_pass():
	return game_state.in_game_state["initialBids"].size() == 0

func get_highest_bid():
	var initial_bids = game_state.in_game_state["initialBids"]
	var highest = -1
	for b in initial_bids:
		if b["bid"] != "pass" and int(b["bid"]) > highest:
			highest = int(b["bid"])
	return highest

func on_button_pressed(input):
	initial_big_dialog_instance.call_deferred("free")
	initial_big_dialog_instance = null
	if input == "pass":
		client.send_obj_to_server({"type": "PASS"})
	else:
		client.send_obj_to_server({
			"type": "BID",
			"bid": input,
		})