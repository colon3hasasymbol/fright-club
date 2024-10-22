extends Node


@onready var hit_shaker: HitShaker = $"../Sprite/HitShaker"
@onready var sprite: AnimatedSprite2D = $"../Sprite"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var health = 100


func _on_hit_box_hit_landed(hitbox: HitBox, _hitdealer: HitDealer, damage: int) -> void:
	print("glomp")
	audio_stream_player.play()
	#get_tree().create_timer(0.3).timeout.connect(hit_shaker.shake)
	hit_shaker.shake()
	health -= damage
	hitbox.dead = health <= 0
	$/root/Main/LevelManager.set_player_health(0 if health < 0 else health)
	print(health)
	if hitbox.dead:
		print("youded")
		sprite.play("die")
		var old_pause_state = PauseSystem.everything_paused
		PauseSystem.everything_paused = true
		await sprite.animation_finished
		PauseSystem.everything_paused = old_pause_state
		sprite.visible = false
		$/root/Main/LevelManager.lose_game()
