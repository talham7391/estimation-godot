extends PanelContainer

func _ready():
	game_state.connect("trump_suit_changed", self, "on_trump_suit_changed")
	on_trump_suit_changed()

func on_trump_suit_changed():
	var trump_suit = game_state.in_game_state["trumpSuit"]
	if trump_suit == null:
		hide()
	else:
		show()
		$MarginContainer/Label.text = "Trump: %s" % trump_suit