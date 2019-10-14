extends Control

var PreGameLobbyPlayerListing = preload("res://scenes/PreGameLobbyPlayerListing.tscn")

onready var party_id_label = $MarginContainer/VBoxContainer/PartyIdLabel/Label
onready var player_container = $MarginContainer/VBoxContainer/PlayersContainer/VBoxContainer
onready var ready_button = $MarginContainer/VBoxContainer/ReadyButton/Button
onready var start_game_button = $MarginContainer/VBoxContainer/StartGameButton/Button
onready var leave_button = $MarginContainer/VBoxContainer/LeaveButton/Button

var PLAYERS_GROUP = "players_group"

func _ready():
	ready_button.connect("pressed", self, "on_ready")
	start_game_button.connect("pressed", self, "on_start_game")
	leave_button.connect("pressed", self, "on_leave")
	
	party_id_label.text = "Party Id: %s" % game_state.connection_party_id
	
	game_state.connect("connection_status_changed", self, "on_connection_status_changed")
	game_state.connect("pre_game_lobby_state_changed", self, "on_pre_game_lobby_state_changed")
	game_state.connect("received_game_state", self, "change_to_in_game")
	on_pre_game_lobby_state_changed()

func on_pre_game_lobby_state_changed():
	var state = game_state.pre_game_lobby_state
	if "readyStatus" in state and state["readyStatus"] != null:
		update_ready_status(state["readyStatus"])
	if "playerScores" in state and state["playerScores"] != null:
		update_player_scores(state["playerScores"])

func update_ready_status(ready_status):
	for obj in ready_status:
		var listing = get_or_create_listing(obj["player"]["connectionId"])
		listing.set_ready(obj["ready"])
		if obj["player"]["connectionId"] == game_state.connection_id and obj["ready"]:
			ready_button.disabled = true
	var all_ready = true
	for listing in get_tree().get_nodes_in_group(PLAYERS_GROUP):
		if not listing.player_ready:
			all_ready = false
			break
	start_game_button.disabled = not all_ready

func update_player_scores(player_scores):
	for obj in player_scores:
		var listing = get_or_create_listing(obj["player"]["connectionId"])
		listing.set_score(obj["score"])

func get_or_create_listing(name):
	var listing = find_listing_for_player(name)
	if listing == null:
		listing = PreGameLobbyPlayerListing.instance()
		listing.add_to_group(PLAYERS_GROUP)
		player_container.add_child(listing)
		listing.set_player_name(name)
	return listing

func find_listing_for_player(name):
	for listing in get_tree().get_nodes_in_group(PLAYERS_GROUP):
		if listing.player_name == name:
			return listing
	return null

func on_ready():
	client.send_obj_to_server({
		"type": "PLAYER_READY",
		"ready": true,
	})
	ready_button.disabled = true

func on_start_game():
	client.send_obj_to_server({
		"type": "START_GAME",
		"start": true,
	})

func on_leave():
	client.close_connection()

func on_connection_status_changed(status, party_id):
	if status == game_state.DISCONNECTED:
		get_tree().change_scene("res://scenes/Home.tscn")

func change_to_in_game():
	get_tree().change_scene("res://scenes/InGame.tscn")
