extends PanelContainer

var score_entry = preload("res://scenes/ScoreEntry.tscn")

onready var entries_container = $MarginContainer/VBoxContainer/VBoxContainer
onready var continue_button = $MarginContainer/VBoxContainer/ContinueButton/Button

func add_entry(name, score):
	var instance = score_entry.instance()
	instance.set_name(name)
	instance.set_score(score)
	entries_container.add_child(instance)

func _ready():
	game_state.connect("pre_game_lobby_state_changed", self, "update_scores")
	continue_button.connect("pressed", self, "on_continue")

func update_scores():
	for child in entries_container.get_children():
		child.call_deferred("free")
	var final_bids = game_state.in_game_state["finalBids"]
	var tricks_won = game_state.in_game_state["playerTricks"]
	for tw in tricks_won:
		for fb in final_bids:
			if tw["player"]["connectionId"] == fb["player"]["connectionId"]:
				add_entry(tw["player"]["connectionId"], calculate_score(int(fb["bid"]), tw["numWon"]))
				break

func calculate_score(target, actual):
	if target == actual:
		if target == 0:
			return 13
		else:
			return target
	else:
		return abs(target - actual) * -1

func on_continue():
	game_state.reset_game_state()
	get_tree().change_scene("res://scenes/InGameLobby.tscn")
