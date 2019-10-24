extends Control


func _ready():
	call_deferred("test")

func test():
	yield(get_tree().create_timer(1.0), "timeout")
	$Card.fade_out_down(50, 0.2)
	$Card2.fade_out_down(100, 0.2)