extends PanelContainer

var party_id_label = null
var player_container = null
var start_game_button = null
var leave_button = null

var PLAYER_NAMES = "player_names"

signal start_game
signal leave

func _ready():
	party_id_label = $VBoxContainer/PartyIdLabel/Label
	start_game_button = $VBoxContainer/StartGameButton/Button
	leave_button = $VBoxContainer/LeaveButton/Button
	player_container = $VBoxContainer/PlayersContainer/VBoxContainer
	
	start_game_button.connect("pressed", self, "on_start_game")
	leave_button.connect("pressed", self, "on_leave")
	
	game_state.connect("connection_status_changed", self, "on_connection_status_changed")
	game_state.connect("connected_players_changed", self, "on_connected_players_changed")
	on_connection_status_changed(game_state.connection_status, game_state.connection_party_id)
	on_connected_players_changed(game_state.connected_players)

func on_start_game():
	emit_signal("start_game")

func on_leave():
	emit_signal("leave")

func on_connection_status_changed(status, party_id):
	party_id_label.text = "Party ID: %s" % party_id

func on_connected_players_changed(players):
	update_names(players)
	update_start_game_button(players)

func update_names(players):
	for p in get_tree().get_nodes_in_group(PLAYER_NAMES):
		p.free()
	for p in players:
		var label = Label.new()
		label.text = p["connectionId"]
		label.align = HALIGN_CENTER
		label.add_to_group(PLAYER_NAMES)
		player_container.add_child(label)

func update_start_game_button(players):
	start_game_button.disabled = len(players) != 1