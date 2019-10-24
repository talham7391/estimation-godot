extends MarginContainer

func set_name(name):
	$HBoxContainer/Name.text = name

func set_score(score):
	$HBoxContainer/Score.text = "%s" % score
