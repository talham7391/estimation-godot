extends Control

var TURN_COLOR = "#009e2b"
var WAIT_COLOR = "#3a3a3a"

var BID_COLOR = "#0099ff"
var PASS_COLOR = "#5e5e5e"

onready var bottom_name_label = $Bottom/Name/Label
onready var left_name_label = $Left/Name/Label
onready var top_name_label = $Top/Name/Label
onready var right_name_label = $Right/Name/Label

onready var bottom_style_box = $Bottom.get("custom_styles/panel")
onready var left_style_box = $Left.get("custom_styles/panel")
onready var top_style_box = $Top.get("custom_styles/panel")
onready var right_style_box = $Right.get("custom_styles/panel")

onready var bottom_bid_container = $BottomBid
onready var left_bid_container = $LeftBid
onready var top_bid_container = $TopBid
onready var right_bid_container = $RightBid

onready var bottom_bid_label = $BottomBid/MarginContainer/Label
onready var left_bid_label = $LeftBid/MarginContainer/Label
onready var top_bid_label = $TopBid/MarginContainer/Label
onready var right_bid_label = $RightBid/MarginContainer/Label

onready var bottom_bid_style_box = $BottomBid.get("custom_styles/panel")
onready var left_bid_style_box = $LeftBid.get("custom_styles/panel")
onready var top_bid_style_box = $TopBid.get("custom_styles/panel")
onready var right_bid_style_box = $RightBid.get("custom_styles/panel")

onready var labels_clockwise = [
	bottom_name_label,
	left_name_label,
	top_name_label,
	right_name_label,
]

onready var bids_containers = [
	bottom_bid_container,
	left_bid_container,
	top_bid_container,
	right_bid_container,
]

onready var bids_clockwise = [
	bottom_bid_label,
	left_bid_label,
	top_bid_label,
	right_bid_label,
]

onready var styles_clockwise = [
	bottom_style_box,
	left_style_box,
	top_style_box,
	right_style_box,
]

onready var bids_styles_clockwise = [
	bottom_bid_style_box,
	left_bid_style_box,
	top_bid_style_box,
	right_bid_style_box,
]

func _ready():
	bottom_style_box.bg_color = Color(WAIT_COLOR)
	left_style_box.bg_color = Color(WAIT_COLOR)
	top_style_box.bg_color = Color(WAIT_COLOR)
	right_style_box.bg_color = Color(WAIT_COLOR)
	
	game_state.connect("turn_order_changed", self, "on_turn_order_changed")
	on_turn_order_changed()
	
	game_state.connect("turn_of_changed", self, "on_turn_of_changed")
	on_turn_of_changed()
	
	game_state.connect("initial_bids_changed", self, "on_bids_changed")
	game_state.connect("final_bids_changed", self, "on_bids_changed")
	on_bids_changed()

func on_turn_order_changed():
	var turn_order = game_state.in_game_state["turnOrder"]
	if not turn_order:
		return
	var shifted_order = utils.put_me_first(turn_order)
	for i in range(labels_clockwise.size()):
		if i >= shifted_order.size():
			labels_clockwise[i].text = "[ Empty ]"
		else:
			labels_clockwise[i].text = shifted_order[i]["connectionId"]

func on_turn_of_changed():
	var turn_of = game_state.in_game_state["turnOf"]
	if turn_of == null:
		return
	var shifted_order = utils.put_me_first(game_state.in_game_state["turnOrder"])
	for i in range(styles_clockwise.size()):
		if i < shifted_order.size() and shifted_order[i]["connectionId"] == turn_of["connectionId"]:
			styles_clockwise[i].bg_color = Color(TURN_COLOR)
		else:
			styles_clockwise[i].bg_color = Color(WAIT_COLOR)

func on_bids_changed():
	for c in bids_containers:
		c.hide()
	var turn_of = game_state.in_game_state["turnOf"]
	var shifted_order = utils.put_me_first(game_state.in_game_state["turnOrder"])
	for i in range(shifted_order.size()):
		update_bid(shifted_order[i]["connectionId"], bids_containers[i], bids_clockwise[i], bids_styles_clockwise[i])

func update_bid(player, container, label, style):
	var phase = game_state.in_game_state["phase"]
	var bids = []
	if phase == "INITIAL_BIDDING" or phase == "DECLARING_TRUMP":
		bids = game_state.in_game_state["initialBids"]
	else:
		bids = game_state.in_game_state["finalBids"]
	for i in bids:
		if i["player"]["connectionId"] == player:
			container.show()
			label.text = "Bid: %s" % i["bid"]
			if i["bid"] == "pass":
				style.bg_color = Color(PASS_COLOR)
			else:
				style.bg_color = Color(BID_COLOR)
			break
