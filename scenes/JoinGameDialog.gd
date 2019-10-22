extends PanelContainer

var party_id_input = null
var join_game_button = null
var cancel_join_button = null

signal party_id

var current_party_id = null

func _ready():
	party_id_input = $MarginContainer/VBoxContainer/PartyIdInput/LineEdit
	party_id_input.connect("text_changed", self, "on_party_id_text_changed")
	join_game_button = $MarginContainer/VBoxContainer/JoinGameButton/Button
	join_game_button.connect("pressed", self, "on_join_game_pressed")
	cancel_join_button = $MarginContainer/VBoxContainer/CancelJoinButton/Button
	cancel_join_button.connect("pressed", self, "on_cancel_join_pressed")

func on_party_id_text_changed(text):
	current_party_id = text

func on_join_game_pressed():
	emit_signal("party_id", current_party_id)

func on_cancel_join_pressed():
	emit_signal("party_id", null)
