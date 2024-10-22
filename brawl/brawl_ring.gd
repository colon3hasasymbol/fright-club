extends Node


@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

var power = 1.0


func _on_enemy_spawn_timer_timeout() -> void:
	EnemySpawner.random_spawn(power)
	power += 0.1
	enemy_spawn_timer.start()
