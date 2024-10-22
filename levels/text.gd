extends Label
class_name CountUpLabel


signal finished

@onready var loop: AudioStreamPlayer = $Loop


func count_up_from_to(start: int, end: int):
	if start != end:
		loop.play()
	var tween = create_tween()
	tween.tween_method(func(num: int): text = str(num), start, end, 1)
	tween.tween_callback(func(): finished.emit(); loop.stop())
