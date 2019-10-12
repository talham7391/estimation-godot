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


var current_game_phase = null
signal current_game_phase_changed

func set_current_game_phase(phase):
	current_game_phase = phase
	emit_signal("current_game_phase_changed", phase)