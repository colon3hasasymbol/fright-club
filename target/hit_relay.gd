extends Node


@onready var hit_shaker: HitShaker = $"../Sprite/HitShaker"
@onready var animation_player: AnimationPlayer = $"../Sprite/AnimationPlayer"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var health = 50


func _on_target_hit_landed(hitbox: HitBox, _hitdealer: HitDealer, damage: int) -> void:
	#get_tree().create_timer(0.3).timeout.connect(hit_shaker.shake)
	audio_stream_player.play()
	hit_shaker.shake()
	health -= damage
	if health <= 10:
		animation_player.play("pulse_modulate_red")
	hitbox.dead = health <= 0
	if hitbox.dead:
		$"..".queue_free()
