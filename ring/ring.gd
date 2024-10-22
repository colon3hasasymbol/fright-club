extends Node


@onready var label: Label = $MarginContainer2/CenterContainer/Label

var existance_time: float = 0.0


func _process(delta: float) -> void:
	if !PauseSystem.is_player_paused():
		existance_time += delta
		label.text = Time.get_time_string_from_unix_time(existance_time)
