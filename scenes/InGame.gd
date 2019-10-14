extends Node2D

func _ready():
	game_state.connect("my_cards_changed", self, "on_my_cards_changed")
	on_my_cards_changed()

func on_my_cards_changed():
	var cards = game_state.in_game_state["myCards"]
	print(cards)
