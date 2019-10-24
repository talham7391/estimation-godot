extends Control

var PreGameLobbyPlayerListing = preload("res://scenes/PreGameLobbyPlayerListing.tscn")
var text_font = preload("res://fonts/text.tres")
var small_number_font = preload("res://fonts/small_number.tres")

onready var party_id_label = $MarginContainer/VBoxContainer/PartyIdLabel/Label
onready var container = $MarginContainer/VBoxContainer/GridContainer
onready var ready_button = $MarginContainer/VBoxContainer/ReadyButton/Button
onready var start_game_button = $MarginContainer/VBoxContainer/StartGameButton/Button
onready var leave_button = $MarginContainer/VBoxContainer/LeaveButton/Button

var GRIP_GROUP = "grid_group"

func _ready():
	ready_button.connect("pressed", self, "on_ready")
	start_game_button.connect("pressed", self, "on_start_game")
	leave_button.connect("pressed", self, "on_leave")
	
	party_id_label.text = "%s" % game_state.connection_party_id
	
	game_state.connect("connection_status_changed", self, "on_connection_status_changed")
	game_state.connect("pre_game_lobby_state_changed", self, "on_pre_game_lobby_state_changed")
	game_state.connect("received_game_state", self, "change_to_in_game")
	on_pre_game_lobby_state_changed()

func on_pre_game_lobby_state_changed():
	for node in get_tree().get_nodes_in_group(GRIP_GROUP):
		node.call_deferred("free")
	var readyStatus = game_state.pre_game_lobby_state["readyStatus"]
	var playerScores = game_state.pre_game_lobby_state["playerScores"]
	var entries = pair_stats(playerScores, readyStatus)
	for k in entries:
		add_entry(k, entries[k]["score"], entries[k]["ready"])
	
	start_game_button.disabled = false
	for status in readyStatus:
		if not status["ready"]:
			start_game_button.disabled = true

func pair_stats(playerScores, readyStatus):
	var ps = playerScores if playerScores != null else []
	var rs = readyStatus if readyStatus != null else []
	var info = {}
	for p in ps:
		var cid = p["player"]["connectionId"]
		if not cid in info:
			info[cid] = {}
		info[cid]["score"] = p["score"]
	for r in rs:
		var cid = r["player"]["connectionId"]
		if not cid in info:
			info[cid] = {}
		info[cid]["ready"] = r["ready"]
	return info

func add_entry(name, score, ready):
	add_value(name, Label.ALIGN_LEFT, false)
	add_value(score, Label.ALIGN_RIGHT, true)
	add_value("READY" if ready else "NOT READY", Label.ALIGN_RIGHT, false)

func add_value(val, alignment, is_number):
	var label = Label.new()
	container.add_child(label)
	label.add_to_group(GRIP_GROUP)
	label.text = "%s" % val
	label.align = alignment
	if is_number:
		label.set("custom_fonts/font", small_number_font)
	else:
		label.set("custom_fonts/font", text_font)

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
