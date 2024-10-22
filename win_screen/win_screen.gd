extends Node


func _ready() -> void:
	$/root/Main/MusicPlayer.fade_to_menu()


func _on_text_finished() -> void:
	if $/root/Main/SettingsManager.was_last_score_high_score:
		$"../MarginContainer/MarginContainer/CountUpLabel".visible = false
		$"../MarginContainer/MarginContainer/Label/AnimationPlayer".play("pulse_visible")
		$AudioStreamPlayer.play()
