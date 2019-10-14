extends Control

func _ready():
	game_state.connect("turn_order_changed", self, "on_turn_order_changed")
	on_turn_order_changed()

func on_turn_order_changed():
	print(game_state.in_game_state["turnOrder"])