extends Node

var client = null
var party_id = null

func _ready():
	client = WebSocketClient.new()
	client.connect("connection_established", self, "on_connection_established")
	client.connect("connection_closed", self, "on_connection_closed")
	client.connect("connection_error", self, "on_connection_error")
	client.connect("data_received", self, "on_data_received")
	client.connect("server_close_request", self, "on_server_close_request")

func connect_to(pid):
	party_id = pid
	print("Connecting")
	client.connect_to_url("%s/connect/%s" % [constants.socket_server, party_id])

func _process(delta):
	if client != null and client.get_connection_status() != WebSocketClient.CONNECTION_DISCONNECTED:
		client.poll()

func on_connection_established(protocol):
	game_state.set_connection_status(game_state.CONNECTED, party_id)
	print("Connected")
	print("Sending connection id to server.")
	var data = {
		"connectionId": game_state.connection_id,
	}
	var err = send_obj_to_server(data)
	print(err)

func on_connection_closed(was_clean_close):
	game_state.set_connection_status(game_state.DISCONNECTED, party_id)
	print("Closed - clean: %s" % was_clean_close)

func on_connection_error():
	print("Error")

func on_data_received():
	var data = client.get_peer(1).get_packet()
	var json = JSON.parse(data.get_string_from_utf8())
	handle_message_from_server(json.result)

func on_server_close_request(code, reason):
	print("Server requested close because: %s" % reason)
	
func send_obj_to_server(data):
	return client.get_peer(1).put_packet(JSON.print(data).to_utf8())

func handle_message_from_server(mssg):
	if mssg["type"] == "CONNECTED_PLAYERS":
		game_state.set_connected_players(mssg["players"])
	elif mssg["type"] == "PRE_GAME_LOBBY_STATE":
		game_state.set_pre_game_lobby_state(mssg)

func close_connection():
	client.disconnect_from_host()
