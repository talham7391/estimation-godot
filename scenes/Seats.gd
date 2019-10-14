extends Control

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

func _ready():
	game_state.connect("turn_order_changed", self, "on_turn_order_changed")
	on_turn_order_changed()

func on_turn_order_changed():
	var turn_order = game_state.in_game_state["turnOrder"]
	if not turn_order:
		return
	var curr_idx = get_my_idx(turn_order)
	for i in range(labels_clockwise.size()):
		if curr_idx >= turn_order.size():
			labels_clockwise[i].text = "[ Empty ]"
		else:
			labels_clockwise[i].text = turn_order[curr_idx]["connectionId"]
		curr_idx = index_after(curr_idx)

func get_my_idx(turn_order):
	for i in range(turn_order.size()):
		if turn_order[i]["connectionId"] == game_state.connection_id:
			return i

func index_after(idx):
	return (idx + 1) % 4