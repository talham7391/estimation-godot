extends Node

var client = null

signal clean_close

func _ready():
	client = WebSocketClient.new()
	client.connect("connection_established", self, "on_connection_established")
	client.connect("connection_closed", self, "on_connection_closed")
	client.connect("connection_error", self, "on_connection_error")
	client.connect("data_received", self, "on_data_received")
	client.connect("server_close_request", self, "on_server_close_request")

	print("Connecting")
	client.connect_to_url("%s/connect/%s" % [constants.socket_server, state.party_id])

func _process(delta):
	if client != null and client.get_connection_status() != WebSocketClient.CONNECTION_DISCONNECTED:
		client.poll()

func on_connection_established(protocol):
	print("Connected")
	print("Sending connection id to server.")
	var data = {
		"connectionId": state.connection_id,
	}
	var err = send_obj_to_server(data)
	print(err)

func on_connection_closed(was_clean_close):
	if was_clean_close:
		emit_signal("clean_close")
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
		connected_players.set_connected_players(mssg["players"])

func close_connection():
	client.disconnect_from_host()
