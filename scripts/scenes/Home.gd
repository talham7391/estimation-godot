extends Control

var client_script = preload("res://scripts/client.gd")

var lobby_on = false
var client = null

func _ready():
	$CreateGameButton.connect("pressed", self, "on_create_game")
	$JoinGameButton.connect("pressed", self, "on_join_game")
	
	$LobbyPanel.connect("on_start_pressed", self, "on_start_pressed")
	$LobbyPanel.connect("on_leave_pressed", self, "on_leave_pressed")
	
	connected_players.connect("connected_players_changed", self, "on_connected_players_changed")
	
	$HTTPRequest.connect("request_completed", self, "on_request_completed")

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

func on_create_game():
	disable_buttons()
	$HTTPRequest.request(
		"%s/games" % constants.web_server,
		PoolStringArray(),
		true,
		HTTPClient.METHOD_POST
	)

func on_join_game():
	print("Hello there!")

func on_start_pressed():
	pass

func on_leave_pressed():
	hide_lobby()

func enable_buttons():
	$CreateGameButton.disabled = false
	$JoinGameButton.disabled = false

func disable_buttons():
	$CreateGameButton.disabled = true
	$JoinGameButton.disabled = true

func show_lobby():
	if lobby_on:
		return
	lobby_on = true
	$LobbyPanel.update_party_id()
	$LobbyPanel.visible = true
	disable_buttons()
	
	client = client_script.new()
	add_child(client)

func hide_lobby():
	if not lobby_on:
		return
	lobby_on = false
	$LobbyPanel.visible = false
	$CreateGameButton.disabled = false
	$JoinGameButton.disabled = false
	enable_buttons()
	
	client.close_connection()
	client.queue_free()
