extends TextureButton

signal card_pressed

var mark_deleted = false
var suit = null
var rank = null
#func _ready():
#	call_deferred("test")

var start_pos = null
func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			start_pos = event.position
		else:
			if start_pos == event.position:
				emit_signal("card_pressed")
			start_pos = null

func set_card(s, r):
	suit = s
	rank = r
	texture_normal = load("res://assets/cards/%s_%s.png" % [suit, rank])

func fade_out(delta_pos, fade_speed, delete_after_fade):
	$Tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		Vector2(rect_position.x + delta_pos.x, rect_position.y + delta_pos.y),
		fade_speed,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		self,
		"modulate",
		Color(modulate.r, modulate.g, modulate.b, 1),
		Color(modulate.r, modulate.g, modulate.b, 0),
		fade_speed,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	$Tween.start()
	if delete_after_fade:
		yield($Tween, "tween_completed")
		call_deferred("free")

func fade_in(delta_pos, fade_speed):
	$Tween.interpolate_property(
		self,
		"rect_position",
		Vector2(rect_position.x + delta_pos.x, rect_position.y + delta_pos.y),
		rect_position,
		fade_speed,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		self,
		"modulate",
		Color(modulate.r, modulate.g, modulate.b, 0),
		Color(modulate.r, modulate.g, modulate.b, 1),
		fade_speed,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	$Tween.start()
