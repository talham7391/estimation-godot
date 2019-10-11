extends Node

var connection_id = "bob"

var connected_players = []
signal connected_players_changed

func set_connected_players(data):
	print(data)
	connected_players = data
	emit_signal("connected_players_changed")
