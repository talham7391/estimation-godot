extends CenterContainer

var Card = preload("res://scenes/Card.tscn")

onready var bottom = $Control/Bottom
onready var left = $Control/Left
onready var top = $Control/Top
onready var right = $Control/Right

onready var spots_clockwise = [
	bottom,
	left,
	top,
	right,
]

var CURRENT_TRICK_GROUP = "current_trick_group"

func _ready():
	game_state.connect("current_trick_changed", self, "on_current_trick_changed")
	on_current_trick_changed()

func on_current_trick_changed():
	clear_current_trick_group()
	var current_trick = game_state.in_game_state["currentTrick"]
	if current_trick.size() == 0:
		current_trick = game_state.in_game_state["previousTrick"]
	display_cards_on_table(current_trick)

func clear_current_trick_group():
	for n in get_tree().get_nodes_in_group(CURRENT_TRICK_GROUP):
		n.call_deferred("free")

func display_cards_on_table(trick):
	var turn_order = game_state.in_game_state["turnOrder"]
	var shifted_order = utils.put_me_first(turn_order)
	for i in range(shifted_order.size()):
		var player = shifted_order[i]["connectionId"]
		for t in trick:
			if t["player"]["connectionId"] == player:
				add_card_to_spot(spots_clockwise[i], t["card"])
				break

func add_card_to_spot(spot, card):
	var c = Card.instance()
	var scale = 0.25
	c.set_scale(Vector2(scale, scale))
	c.set_card(card["suit"], card["rank"])
	c.add_to_group(CURRENT_TRICK_GROUP)
	spot.add_child(c)