extends Node

var connection_id = "bob"


enum { CONNECTED, RECONNECTING, DISCONNECTED }
var connection_status = DISCONNECTED
var connection_party_id = null
signal connection_status_changed

func set_connection_status(status, party_id):
	connection_status = status
	connection_party_id = party_id
	emit_signal("connection_status_changed", status, party_id)


var connected_players = []
signal connected_players_changed

func set_connected_players(data):
	connected_players = data
	emit_signal("connected_players_changed", data)


var pre_game_lobby_state = {
	"readyStatus": [],
	"playerScores": [],
}
signal pre_game_lobby_state_changed

func set_pre_game_lobby_state(state):
	var keys_to_update = [
		"readyStatus",
		"playerScores",
	]
	for key in keys_to_update:
		update_key(pre_game_lobby_state, state, key, "pre_game_lobby_state_changed")


var in_game_state = {
	"done": false,
	"myCards": [],
	"playerCards": [],
	"initialBids": [],
	"turnOf": null,
	"phase": null,
	"finalBids": [],
	"trumpSuit": null,
	"playerTricks": [],
	"turnOrder": [],
	"currentTrick": [],
}
signal done_changed
signal my_cards_changed
signal turn_order_changed
signal phase_changed
signal turn_of_changed
signal initial_bids_changed
signal trump_suit_changed
signal final_bids_changed
signal received_game_state

func set_game_state(state):
	var info_pairs = [
		{"info": "done", "signal": "done_changed"},
		{"info": "myCards", "signal": "my_cards_changed"},
		{"info": "turnOrder", "signal": "turn_order_changed"},
		{"info": "phase", "signal": "phase_changed"},
		{"info": "initialBids", "signal": "initial_bids_changed"},
		{"info": "trumpSuit", "signal": "trump_suit_changed"},
		{"info": "finalBids", "signal": "final_bids_changed"},
		{"info": "turnOf", "signal": "turn_of_changed"},
	]
	for pair in info_pairs:
		update_key(in_game_state, state, pair["info"], pair["signal"])
	emit_signal("received_game_state")


func update_key(dest, src, key, signal_on_change):
	if src[key] != null:
		dest[key] = src[key]
		emit_signal(signal_on_change)
	return dest

