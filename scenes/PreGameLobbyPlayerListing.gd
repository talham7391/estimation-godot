extends MarginContainer

onready var player_name_label = $HBoxContainer/VBoxContainer/PlayerNameLabel/Label
onready var score_label = $HBoxContainer/VBoxContainer/ScoreLabel/Label
onready var ready_label = $HBoxContainer/ReadyStatus

var player_name = null
var player_score = null
var player_ready = null

func set_player_name(n):
	player_name = n
	player_name_label.text = player_name

func set_score(s):
	player_score = s
	score_label.text = "Score: %s" % player_score

func set_ready(r):
	player_ready = r
	if player_ready:
		ready_label.text = "READY"
	else:
		ready_label.text= "NOT READY"
