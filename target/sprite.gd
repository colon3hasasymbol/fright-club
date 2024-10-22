extends Node


@export var sprite_frames_array: Array[SpriteFrames]


func _ready() -> void:
	get_parent().sprite_frames = sprite_frames_array[randi_range(0, sprite_frames_array.size() - 1)]
