extends Label


@onready var settings_manager: SettingsManager = $/root/Main/SettingsManager


func _ready() -> void:
	text = str(settings_manager.get_high_score())
