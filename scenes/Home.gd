extends Control

var create_game_action = preload("res://scripts/actions/create_game.gd")
var create_game_action_instance = null

var join_game_dialog = preload("res://scenes/JoinGameDialog.tscn")
var join_game_dialog_instance = null

var client = preload("res://scripts/client.gd")
var client_instance = null

var name_input = null
var create_game_button = null
var join_game_button = null
var join_game_dialog_parent = null

func buttons_in_menu():
	return [
		create_game_button,
		join_game_button,
	]

func inputs_in_menu():
	return [
		name_input,
	]

func _ready():
	name_input = $CenterContainer/VBoxContainer/NameInput/LineEdit
	name_input.text = game_state.connection_id
	name_input.connect("text_changed", self, "on_text_changed")
	create_game_button = $CenterContainer/VBoxContainer/CreateGameButton/Button
	create_game_button.connect("pressed", self, "on_create_game_button_pressed")
	join_game_button = $CenterContainer/VBoxContainer/JoinGameButton/Button
	join_game_button.connect("pressed", self, "on_join_game_button_pressed")
	join_game_dialog_parent = $CenterContainer

func on_text_changed(text):
	game_state.connection_id = text

func on_create_game_button_pressed():
	if create_game_action_instance != null:
		return
	disable_menu()
	create_game_action_instance = create_game_action.new()
	add_child(create_game_action_instance)
	create_game_action_instance.connect("party_id", self, "on_party_id_created")
	create_game_action_instance.create_game()

func on_party_id_created(party_id):
	create_game_action_instance.call_deferred("free")
	create_game_action_instance = null
	if party_id == null:		
		enable_menu()
	else:
		start_client(party_id)

func on_join_game_button_pressed():
	if join_game_dialog_instance != null:
		return
	disable_menu()
	join_game_dialog_instance = join_game_dialog.instance()
	join_game_dialog_parent.add_child(join_game_dialog_instance)
	join_game_dialog_instance.connect("party_id", self, "on_party_id_joined")

func on_party_id_joined(party_id):
	join_game_dialog_instance.call_deferred("free")
	join_game_dialog_instance = null
	if party_id == null:
		enable_menu()
	else:
		start_client(party_id)

func start_client(party_id):
	if client_instance != null:
		return
	client_instance = client.new()
	add_child(client_instance)
	client_instance.connect("clean_close", self, "on_clean_close")
	client_instance.connect_to(party_id)
	print(party_id)

func on_clean_close():
	client_instance.call_deferred("free")
	client_instance = null
	enable_menu()

func disable_menu():
	for el in buttons_in_menu():
		el.disabled = true
	for el in inputs_in_menu():
		el.focus_mode = FOCUS_NONE
		el.editable = false

func enable_menu():
	for el in buttons_in_menu():
		el.disabled = false
	for el in inputs_in_menu():
		el.focus_mode = FOCUS_CLICK
		el.editable = true