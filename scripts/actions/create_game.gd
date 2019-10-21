extends Node

var http_request = null

signal party_id

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "on_request_completed")

func on_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS || response_code != HTTPClient.RESPONSE_OK:
		emit_signal("party_id", null)
	else:
		var json = JSON.parse(body.get_string_from_utf8())
		var data = json.result
		emit_signal("party_id", data["partyId"])

func create_game():
	http_request.request(
		"%s/games" % constants.web_server,
		PoolStringArray(),
		true,
		HTTPClient.METHOD_POST
	)