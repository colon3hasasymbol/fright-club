extends CanvasLayer
class_name SlideInMenu


@export var autoslide = false

signal finished
signal finished_reverse


func _ready() -> void:
	if autoslide:
		slide()


func slide_reversed():
	var tween = create_tween()
	tween.tween_method(slide_from_time, 1.0, 0.0, 0.5)
	tween.tween_callback(finished_reverse.emit)


func slide():
	var tween = create_tween()
	tween.tween_method(slide_from_time, 0.0, 1.0, 0.5)
	tween.tween_callback(finished.emit)


func slide_from_time(time: float):
	var full_slide = 0
	var full_unslide = -get_window().size.x
	offset.x = lerp(full_unslide, full_slide, time)
