extends Label


func _ready() -> void:
	text = str($/root/Main/SettingsManager.get_high_brawl_score())
