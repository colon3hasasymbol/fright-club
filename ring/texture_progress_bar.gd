extends TextureProgressBar


signal finished


func slide_from_to(from: int, to: int):
	value = from
	var tween = create_tween()
	tween.tween_property(self, "value", to, 0.5)
	tween.tween_callback(finished.emit)
