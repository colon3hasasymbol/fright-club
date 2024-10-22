extends TextureButton


@onready var node: SlideInMenu = $"../.."
@onready var settings_manager: SettingsManager = $/root/Main/SettingsManager


func _on_button_up() -> void:
	settings_manager.save_settings()
	node.slide_reversed()
	await node.finished_reverse
	node.queue_free()
