extends Node2D


@onready var animated: Node2D = $Animated
@onready var animation_player: AnimationPlayer = $Animated/AnimationPlayer


func drop_enemy(enemy: Node):
	animated.add_child(enemy)
	animation_player.play("toss_right")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
