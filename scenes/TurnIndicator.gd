extends ColorRect

var FADE_SPEED = 0.2
var IN_COLOR = Color(0.35, 0.63, 0.11, 1)
var OUT_COLOR = Color(0.35, 0.63, 0.11, 0)

func pulse():
	while true:
		fade_out()
		yield(get_tree().create_timer(0.3), "timeout")
		fade_in()
		yield(get_tree().create_timer(0.3), "timeout")

func fade_out():
	$Tween.stop_all()
	$Tween.interpolate_property(
		self,
		"color",
		color,
		OUT_COLOR,
		FADE_SPEED,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$Tween.start()

func fade_in():
	$Tween.stop_all()
	$Tween.interpolate_property(
		self,
		"color",
		color,
		IN_COLOR,
		FADE_SPEED,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$Tween.start()