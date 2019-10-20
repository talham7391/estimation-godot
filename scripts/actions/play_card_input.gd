extends Node

func _ready():
	game_state.connect("play_card", self, "on_play_card")

func on_play_card(suit, rank):
	client.send_obj_to_server({
		"type": "PLAY_CARD",
		"suit": suit,
		"rank": rank,
	})
