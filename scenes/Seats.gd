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

onready var bottom_initial_bid_container = $BottomInitialBid
onready var left_initial_bid_container = $LeftInitialBid
onready var top_initial_bid_container = $TopInitialBid
onready var right_initial_bid_container = $RightInitialBid

onready var bottom_initial_bid_label = $BottomInitialBid/MarginContainer/Label
onready var left_initial_bid_label = $LeftInitialBid/MarginContainer/Label
onready var top_initial_bid_label = $TopInitialBid/MarginContainer/Label
onready var right_initial_bid_label = $RightInitialBid/MarginContainer/Label

onready var bottom_initial_bid_style_box = $BottomInitialBid.get("custom_styles/panel")
onready var left_initial_bid_style_box = $LeftInitialBid.get("custom_styles/panel")
onready var top_initial_bid_style_box = $TopInitialBid.get("custom_styles/panel")
onready var right_initial_bid_style_box = $RightInitialBid.get("custom_styles/panel")

onready var labels_clockwise = [
	bottom_name_label,
	left_name_label,
	top_name_label,
	right_name_label,
]

onready var initial_bids_containers = [
	bottom_initial_bid_container,
	left_initial_bid_container,
	top_initial_bid_container,
	right_initial_bid_container,
]

onready var initial_bids_clockwise = [
	bottom_initial_bid_label,
	left_initial_bid_label,
	top_initial_bid_label,
	right_initial_bid_label,
]

onready var styles_clockwise = [
	bottom_style_box,
	left_style_box,
	top_style_box,
	right_style_box,
]

onready var initial_bids_styles_clockwise = [
	bottom_initial_bid_style_box,
	left_initial_bid_style_box,
	top_initial_bid_style_box,
	right_initial_bid_style_box,
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
	
	game_state.connect("initial_bids_changed", self, "on_initial_bids_changed")
	on_initial_bids_changed()

func on_turn_order_changed():
	var turn_order = game_state.in_game_state["turnOrder"]
	if not turn_order:
		return
	var shifted_order = put_me_first(turn_order)
	for i in range(labels_clockwise.size()):
		if i >= shifted_order.size():
			labels_clockwise[i].text = "[ Empty ]"
		else:
			labels_clockwise[i].text = shifted_order[i]["connectionId"]

func on_turn_of_changed():
	var turn_of = game_state.in_game_state["turnOf"]
	var shifted_order = put_me_first(game_state.in_game_state["turnOrder"])
	for i in range(styles_clockwise.size()):
		if i < shifted_order.size() and shifted_order[i]["connectionId"] == turn_of["connectionId"]:
			styles_clockwise[i].bg_color = Color(TURN_COLOR)
		else:
			styles_clockwise[i].bg_color = Color(WAIT_COLOR)

func on_initial_bids_changed():
	for c in initial_bids_containers:
		c.hide()
	var turn_of = game_state.in_game_state["turnOf"]
	var shifted_order = put_me_first(game_state.in_game_state["turnOrder"])
	for i in range(shifted_order.size()):
		update_initial_bid(shifted_order[i]["connectionId"], initial_bids_containers[i], initial_bids_clockwise[i], initial_bids_styles_clockwise[i])

func update_initial_bid(player, container, label, style):
	var initial_bids = game_state.in_game_state["initialBids"]
	for i in initial_bids:
		if i["player"]["connectionId"] == player:
			container.show()
			label.text = "Bid: %s" % i["bid"]
			if i["bid"] == "pass":
				style.bg_color = Color(PASS_COLOR)
			else:
				style.bg_color = Color(BID_COLOR)
			break

func put_me_first(turn_order):
	if not turn_order:
		return turn_order
	var shifted_order = turn_order.duplicate()
	for i in range(4):
		if shifted_order[0]["connectionId"] == game_state.connection_id:
			break
		else:
			shifted_order.push_back(shifted_order.pop_front())
	return shifted_order