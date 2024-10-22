extends Label


signal finished


func _ready() -> void:
	count_up_to($/root/Main/LevelManager.score)


func count_up_to(value: int):
	var tween = create_tween()
	tween.tween_method(func(num: int): text = str(num), 0, value, 2)
	tween.tween_callback(finished.emit)
