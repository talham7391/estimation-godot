extends Control

func _ready():
	game_state.connect("pre_game_lobby_state_changed", self, "change_to_in_game_lobby")

func change_to_in_game_lobby():
	print("goto pregame lobby")
