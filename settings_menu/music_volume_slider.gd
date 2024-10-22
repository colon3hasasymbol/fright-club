extends HSlider


@onready var settings_manager: SettingsManager = $/root/Main/SettingsManager


func _ready() -> void:
	value = settings_manager.get_volume(1)


func _on_value_changed(i: float) -> void:
	settings_manager.set_volume(1, value)
