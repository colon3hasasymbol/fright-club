extends AnimationPlayer


var _finished = false


func _ready() -> void:
	PauseSystem.signal_container.player_paused_changed.connect(func(value: bool): if value: pause() elif !is_playing() && !_finished: play())


func _on_animation_finished(anim_name: StringName) -> void:
	_finished = true
	PauseSystem.everything_paused = false
	queue_free()
