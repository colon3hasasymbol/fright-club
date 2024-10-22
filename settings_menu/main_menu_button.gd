extends TextureButton


@onready var node: SlideInMenu = $"../.."


func _on_button_up() -> void:
	node.slide_reversed()
	await node.finished_reverse
	node.queue_free()
