extends Control

var client_script = preload("res://scripts/client.gd")

var lobby_on = false
var client = null

var create_game_button = null
var join_game_button = null

func _ready():
	$CenterContainer/VBoxContainer/NameInputContainer/LineEdit.text = state.connection_id
	$CenterContainer/VBoxContainer/NameInputContainer/LineEdit.connect("text_changed", self, "on_name_change")
	create_game_button = $CenterContainer/VBoxContainer/CreateGameButtonContainer/CreateGameButton
	join_game_button = $CenterContainer/VBoxContainer/JoinGameButtonContainer/JoinGameButton
	
	create_game_button.connect("pressed", self, "on_create_game")
	join_game_button.connect("pressed", self, "on_join_game")
	
	$LobbyPanel.connect("on_start_pressed", self, "on_start_pressed")
	$LobbyPanel.connect("on_leave_pressed", self, "on_leave_pressed")
	
	$JoinLobby/JoinLobbyPopup.connect("submit_pressed", self, "on_submit_join_game")
	$JoinLobby/JoinLobbyPopup.connect("cancel_pressed", self, "on_cancel_join_game")
	
	connected_players.connect("connected_players_changed", self, "on_connected_players_changed")
	
	$CreateRequest.connect("request_completed", self, "on_request_completed")

func on_connected_players_changed():
	var names = []
	for i in connected_players.connected_players:
		names.append(i["connectionId"])
	$LobbyPanel.set_names(names)

func on_request_completed(result, response_code, headers, body):
	if response_code == HTTPClient.RESPONSE_OK:
		var json = JSON.parse(body.get_string_from_utf8())
		var data = json.result
		var party_id = data["partyId"]
		if party_id != null:
			state.party_id = party_id
			print(state.party_id)
			show_lobby()
	else:
		enable_buttons()

func on_join_request_completed(result, response_code, headers, body):
	pass

func on_name_change(name):
	state.connection_id = name

func on_create_game():
	disable_buttons()
	$CreateRequest.request(
		"%s/games" % constants.web_server,
		PoolStringArray(),
		true,
		HTTPClient.METHOD_POST
	)

func on_join_game():
	$CenterContainer.hide()
	$JoinLobby.show()

func on_cancel_join_game():
	$CenterContainer.show()
	$JoinLobby.hide()

func on_submit_join_game():
	state.party_id = $JoinLobby/JoinLobbyPopup.party_id
	$JoinLobby.hide()
	show_lobby()

func on_start_pressed():
	pass

func on_leave_pressed():
	hide_lobby()

func enable_buttons():
	create_game_button.disabled = false
	join_game_button.disabled = false

func disable_buttons():
	create_game_button.disabled = true
	join_game_button.disabled = true

func show_lobby():
	if lobby_on:
		return
	lobby_on = true
	$LobbyPanel.update_party_id()
	$LobbyPanel.visible = true
	disable_buttons()
	$CenterContainer.hide()
	
	client = client_script.new()
	client.connect("clean_close", self, "on_clean_close")
	add_child(client)

func on_clean_close():
	hide_lobby()
	
func hide_lobby():
	if not lobby_on:
		return
	lobby_on = false
	$LobbyPanel.visible = false
	create_game_button.disabled = false
	join_game_button.disabled = false
	enable_buttons()
	$CenterContainer.show()
	
	client.close_connection()
	client.queue_free()
