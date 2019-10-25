extends PanelContainer

func _ready():
	modulate = Color(1,1,1,0)

func set_bid(bid):
	$MarginContainer/Label.text = bid

func animate_in_out(delta, delay_before_delete):
	var anim_speed = 0.25
	$Tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		Vector2(rect_position.x + delta.x, rect_position.y + delta.y),
		anim_speed,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		self,
		"modulate",
		Color(1,1,1,0),
		Color(1,1,1,1),
		anim_speed,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	$Tween.start()
	yield($Tween, "tween_completed")
	yield(get_tree().create_timer(delay_before_delete), "timeout")
	$Tween.start()
	$Tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		Vector2(rect_position.x - delta.x, rect_position.y - delta.y),
		anim_speed,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		self,
		"modulate",
		Color(1,1,1,1),
		Color(1,1,1,0),
		anim_speed,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	yield($Tween, "tween_completed")
	call_deferred("free")