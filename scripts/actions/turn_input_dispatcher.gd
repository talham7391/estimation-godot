extends Node

var initial_bid_input = preload("res://scripts/actions/initial_bid_input.gd")
var declare_trump_input = preload("res://scripts/actions/declare_trump_input.gd")
var final_bid_input = preload("res://scripts/actions/final_bid_input.gd")
var play_card_input = preload("res://scripts/actions/play_card_input.gd")
var dispatched = null

var dispatch_map = {
	"INITIAL_BIDDING": "dispatch_initial_bidding",
	"DECLARING_TRUMP": "dispatch_declaring_trump",
	"FINAL_BIDDING": "dispatch_final_bidding",
	"TRICK_TAKING": "dispatch_trick_taking",
}

func _ready():
	game_state.connect("turn_of_changed", self, "run_dispatch")
	run_dispatch()

func run_dispatch():
	if dispatched != null:
		dispatched.call_deferred("free")
		dispatched = null
	if game_state.in_game_state["turnOf"] == null:
		return
	if game_state.in_game_state["turnOf"]["connectionId"] == game_state.connection_id:
		var phase = game_state.in_game_state["phase"]
		call(dispatch_map[phase])

func dispatch_initial_bidding():
	dispatched = initial_bid_input.new()
	add_child(dispatched)

func dispatch_declaring_trump():
	dispatched = declare_trump_input.new()
	add_child(dispatched)

func dispatch_final_bidding():
	dispatched = final_bid_input.new()
	add_child(dispatched)

func dispatch_trick_taking():
	dispatched = play_card_input.new()
	add_child(dispatched)

