extends CenterContainer

var bidpopup = preload("res://scenes/BidPopup.tscn")

onready var left = $Control/Left
onready var top = $Control/Top
onready var right = $Control/Right

onready var clockwise = [
	null,
	left,
	top,
	right,
]

func _ready():
	game_state.connect("bid_event", self, "on_bid_event")

func on_bid_event(bid):
	var turn_order = game_state.in_game_state["turnOrder"]
	var shifted_order = utils.put_me_first(turn_order)
	
	var direction = player_with_bid(shifted_order, bid)
	
	if direction <= 0:
		return
	
	var popup = bidpopup.instance()
	clockwise[direction].add_child(popup)
	popup.set_bid(bid["bid"])
	
	var dist = 40
	var x = 0
	var y = 0
	if direction == 1:
		x = dist
	if direction == 2:
		y = dist
	if direction == 3:
		x = dist * -1
	
	popup.animate_in_out(Vector2(x, y), 1.5) 


func player_with_bid(shifted_order, bid):
	for i in range(shifted_order.size()):
		var player = shifted_order[i]
		if player["connectionId"] == bid["player"]["connectionId"]:
			return i
	return -1