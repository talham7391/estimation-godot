extends PanelContainer

var NameContainer = preload("res://scenes/home/NameContainer.tscn")

signal on_start_pressed
signal on_leave_pressed

func update_party_id():
	$VBoxContainer/JoinCodeContainer/JoinCode.text = "Join Code: %s" % state.party_id

func set_names(names):
	var prev_instances = get_tree().get_nodes_in_group("name_instances")
	for i in prev_instances:
		i.free()
	for name in names:
		var nameContainer = NameContainer.instance()
		nameContainer.set_name(name)
		nameContainer.add_to_group("name_instances")
		$VBoxContainer.add_child(nameContainer)

func _ready():
	$VBoxContainer/StartGameButton.connect("pressed", self, "on_start")
	$VBoxContainer/LeaveGameButton.connect("pressed", self, "on_leave")

func on_start():
	emit_signal("on_start_pressed")

func on_leave():
	emit_signal("on_leave_pressed")