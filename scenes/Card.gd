extends TextureButton

signal card_pressed

var start_pos = null
func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			start_pos = event.position
		else:
			if start_pos == event.position:
				emit_signal("card_pressed")
			start_pos = null

func set_card(suit, rank):
	texture_normal = load("res://assets/cards/%s_%s.png" % [suit, rank])