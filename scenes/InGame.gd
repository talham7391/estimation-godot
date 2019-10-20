extends Control

onready var score_dialog = $ScoreDialogContainer

func _ready():
	score_dialog.hide()
	game_state.connect("pre_game_lobby_state_changed", self, "show_score_dialog")

func show_score_dialog():
	score_dialog.show()
