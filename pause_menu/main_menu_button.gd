extends TextureButton


@onready var node: SlideInMenu = $"../../../.."


func _on_button_up() -> void:
	node.slide_reversed()
