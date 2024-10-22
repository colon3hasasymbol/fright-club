extends AudioStreamPlayer


func _ready() -> void:
	$"../../YSortNode/Player/AnimationPlayer".animation_finished.connect(func(_n: StringName): play())
