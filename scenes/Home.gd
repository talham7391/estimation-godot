extends Control

#####################################################################
##  IMPORTED SCENES AND SCRIPTS  ####################################
#####################################################################

var create_game_action = preload("res://scripts/actions/create_game.gd")
var create_game_action_instance = null

var join_game_dialog = preload("res://scenes/JoinGameDialog.tscn")
var join_game_dialog_instance = null

var lobby_dialog = preload("res://scenes/LobbyDialog.tscn")
var lobby_dialog_instance = null

#####################################################################
##  UI ELEMENTS  ####################################################
#####################################################################

var name_input = null
var create_game_button = null
var join_game_button = null
var join_game_dialog_parent = null
var lobby_dialog_parent = null

func buttons_in_menu():
	return [
		create_game_button,
		join_game_button,
	]

func inputs_in_menu():
	return [
		name_input,
	]

#####################################################################
##  GAME LOGIC  #####################################################
#####################################################################

func _ready():
	name_input = $CenterContainer/VBoxContainer/NameInput/LineEdit
	name_input.text = game_state.connection_id
	name_input.connect("text_changed", self, "on_text_changed")
	create_game_button = $CenterContainer/VBoxContainer/CreateGameButton/Button
	create_game_button.connect("pressed", self, "on_create_game_button_pressed")
	join_game_button = $CenterContainer/VBoxContainer/JoinGameButton/Button
	join_game_button.connect("pressed", self, "on_join_game_button_pressed")
	join_game_dialog_parent = $CenterContainer
	lobby_dialog_parent = $CenterContainer
	
	game_state.connect("connection_status_changed", self, "on_connection_status_changed")
	game_state.connect("pre_game_lobby_state_changed", self, "change_to_in_game_lobby")
	game_state.connect("received_game_state", self, "change_to_in_game")

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
	enable_menu()
	if party_id != null:
		start_client(party_id)
	else:
		NotificationManager.display_notification("Error creating game.")

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
	enable_menu()
	if party_id != null:
		start_client(party_id)

func start_client(party_id):
	client.connect_to(party_id)
	print(party_id)

func on_connection_status_changed(status, party_id):
	if status == game_state.CONNECTED:
		disable_menu()
		lobby_dialog_instance = lobby_dialog.instance()
		lobby_dialog_instance.connect("start_game", self, "on_start_game")
		lobby_dialog_instance.connect("leave", self, "on_leave_lobby")
		lobby_dialog_parent.add_child(lobby_dialog_instance)
	elif status == game_state.DISCONNECTED:
		lobby_dialog_instance.call_deferred("free")
		lobby_dialog_instance = null
		enable_menu()

func on_start_game():
	disable_menu()
	lobby_dialog_instance.call_deferred("free")
	lobby_dialog_instance = null
	client.send_obj_to_server({
		"ready": true,
	})

func change_to_in_game_lobby():
	get_tree().change_scene("res://scenes/InGameLobby.tscn")

func change_to_in_game():
	get_tree().change_scene("res://scenes/InGame.tscn")

func on_leave_lobby():
	client.close_connection()

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