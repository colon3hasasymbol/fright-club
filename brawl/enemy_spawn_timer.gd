extends Timer


func _ready() -> void:
	paused = PauseSystem.is_enemies_paused()
	PauseSystem.signal_container.enemies_paused_changed.connect(func(value: bool): paused = value)
