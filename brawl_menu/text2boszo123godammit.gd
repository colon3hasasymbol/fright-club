extends Label


func _ready() -> void:
	text = Time.get_time_string_from_unix_time($/root/Main/SettingsManager.get_high_brawl_time())
