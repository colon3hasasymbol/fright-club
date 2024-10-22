extends Timer


@onready var attack_windup_start_area: Area2D = $"../../AttackWindupStartArea"
@onready var sprite: AnimatedSprite2D = $"../../../Sprite"


func _ready() -> void:
	paused = PauseSystem.is_enemies_paused()
	PauseSystem.signal_container.enemies_paused_changed.connect(func(value: bool): paused = value)


func _on_timeout() -> void:
	print("wjhefhj")
	get_parent().disabled = false
	sprite.update_punching(true)
	sprite.flush_to_animation()
	get_tree().create_timer(0.2).timeout.connect(func(): get_parent().disabled = true; sprite.update_punching(false); sprite.flush_to_animation())


func _process(delta: float) -> void:
	if is_stopped():
		for area in attack_windup_start_area.get_overlapping_areas():
			if area is HitBox:
				print("jkgoog")
				start()
				return
