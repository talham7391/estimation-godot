extends Control

onready var clockwise = [
	{
		"turn_indicator": $Bottom/PanelContainer/TurnIndicator,
		"name_label": $Bottom/PanelContainer/HBoxContainer/Name/Label,
		"bid_label": $Bottom/PanelContainer/HBoxContainer/Bid/MarginContainer/Label,
		"num_won_label": $Bottom/PanelContainer/HBoxContainer/NumWon/Label,
	},{
		"turn_indicator": $Left/PanelContainer/TurnIndicator,
		"name_label": $Left/PanelContainer/VBoxContainer/Control/Name/Label,
		"bid_label": $Left/PanelContainer/VBoxContainer/Bid/MarginContainer/Label,
		"num_won_label": $Left/PanelContainer/VBoxContainer/NumWon/Label,
	},{
		"turn_indicator": $Top/PanelContainer/TurnIndicator,
		"name_label": $Top/PanelContainer/HBoxContainer/Name/Label,
		"bid_label": $Top/PanelContainer/HBoxContainer/Bid/MarginContainer/Label,
		"num_won_label": $Top/PanelContainer/HBoxContainer/NumWon/Label,
	},{
		"turn_indicator": $Right/PanelContainer/TurnIndicator,
		"name_label": $Right/PanelContainer/VBoxContainer/Control/Name/Label,
		"bid_label": $Right/PanelContainer/VBoxContainer/Bid/MarginContainer/Label,
		"num_won_label": $Right/PanelContainer/VBoxContainer/NumWon/Label,
	}
]

func _ready():
	set_turn_indicator_off_for_everyone()
	
	game_state.connect("turn_order_changed", self, "on_turn_order_changed")
	on_turn_order_changed()
	
	game_state.connect("turn_of_changed", self, "on_turn_of_changed")
	on_turn_of_changed()
	
	game_state.connect("initial_bids_changed", self, "on_bids_changed")
	game_state.connect("final_bids_changed", self, "on_bids_changed")
	on_bids_changed()
	
	game_state.connect("player_tricks_changed", self, "on_player_tricks_changed")
	on_player_tricks_changed()

func set_turn_indicator_off_for_everyone():
	for p in clockwise:
		p["turn_indicator"].fade_out()

func on_turn_order_changed():
	var turn_order = game_state.in_game_state["turnOrder"]
	if not turn_order:
		return
	var shifted_order = utils.put_me_first(turn_order)
	for i in range(clockwise.size()):
		if i >= shifted_order.size():
			clockwise[i]["name_label"].text = "[ Empty ]"
		else:
			clockwise[i]["name_label"].text = shifted_order[i]["connectionId"]

func on_turn_of_changed():
	var turn_of = game_state.in_game_state["turnOf"]
	if turn_of == null:
		return
	set_turn_indicator_off_for_everyone()
	var shifted_order = utils.put_me_first(game_state.in_game_state["turnOrder"])
	for i in range(clockwise.size()):
		if i < shifted_order.size() and shifted_order[i]["connectionId"] == turn_of["connectionId"]:
			clockwise[i]["turn_indicator"].fade_in()

func on_bids_changed():
	var turn_of = game_state.in_game_state["turnOf"]
	var shifted_order = utils.put_me_first(game_state.in_game_state["turnOrder"])
	for i in range(shifted_order.size()):
		update_bid(shifted_order[i]["connectionId"], clockwise[i]["bid_label"])

func update_bid(player, label):
	var phase = game_state.in_game_state["phase"]
	var bids = []
	if phase == "INITIAL_BIDDING" or phase == "DECLARING_TRUMP":
		bids = game_state.in_game_state["initialBids"]
	else:
		bids = game_state.in_game_state["finalBids"]
	for i in bids:
		if i["player"]["connectionId"] == player:
			label.text = "%s" % i["bid"]
			if i["bid"] == "pass":
				label.text = "P"

func on_player_tricks_changed():
	for tw in clockwise:
		tw["num_won_label"].text = "x0"
	var player_tricks = game_state.in_game_state["playerTricks"]
	var shifted_order = utils.put_me_first(game_state.in_game_state["turnOrder"])
	for i in range(shifted_order.size()):
		for pt in player_tricks:
			if pt["player"]["connectionId"] == shifted_order[i]["connectionId"]:
				clockwise[i]["num_won_label"].text = "x%s" % pt["numWon"]
				break