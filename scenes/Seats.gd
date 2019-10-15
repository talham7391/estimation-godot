extends Control

var TURN_COLOR = "#009e2b"
var WAIT_COLOR = "#3a3a3a"

onready var bottom_name_label = $Bottom/Name/Label
onready var left_name_label = $Left/Name/Label
onready var top_name_label = $Top/Name/Label
onready var right_name_label = $Right/Name/Label

onready var labels_clockwise = [
	bottom_name_label,
	left_name_label,
	top_name_label,
	right_name_label,
]

onready var bottom_style_box = $Bottom.get("custom_styles/panel")
onready var left_style_box = $Left.get("custom_styles/panel")
onready var top_style_box = $Top.get("custom_styles/panel")
onready var right_style_box = $Right.get("custom_styles/panel")

onready var styles_clockwise = [
	bottom_style_box,
	left_style_box,
	top_style_box,
	right_style_box,
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