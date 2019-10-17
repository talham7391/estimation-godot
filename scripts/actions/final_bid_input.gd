extends Node

var final_bid_dialog = preload("res://scenes/BidInputDialog.tscn")
var final_big_dialog_instance = null

func _ready():
	final_big_dialog_instance = final_bid_dialog.instance()
	final_big_dialog_instance.connect("button_pressed", self, "on_button_pressed")
	add_child(final_big_dialog_instance)
	final_big_dialog_instance.disable_pass()
	final_big_dialog_instance.disable_range(get_highest_bid() + 1, 13)

func get_highest_bid():
	var final_bids = game_state.in_game_state["finalBids"]
	var highest = -1
	for b in final_bids:
		if int(b["bid"]) > highest:
			highest = int(b["bid"])
	return highest

func on_button_pressed(input):
	final_big_dialog_instance.call_deferred("free")
	final_big_dialog_instance = null
	client.send_obj_to_server({
		"type": "BID",
		"bid": input,
	})