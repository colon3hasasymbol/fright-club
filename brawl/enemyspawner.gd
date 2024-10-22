extends Node2D
class_name EnemySpawner


@export var enemy_scene: PackedScene
@export var enemy_spawn_function_name: StringName

static var spawners: Array[Node]


func _ready() -> void:
	add_to_group("enemy_spawners")
	spawners = get_tree().get_nodes_in_group("enemy_spawners")


func spawn(power: float):
	if enemy_scene:
		var node = enemy_scene.instantiate()
		if node.get_script() == load("res://target/movement.gd"):
			power *= 4.0
			
			var x = randf()
			var y = randf()
			var z = randf()
			
			while y == x:
				y = randf()
			
			while z == x:
				z = randf()
			
			x = move_toward(x, 0.25, abs(x - 0.25) / 1.4)
			y = move_toward(y, 0.5, abs(y - 0.5) / 1.4)
			z = move_toward(z, 0.75, abs(z - 0.75) / 1.4)
			
			var var1 = x * power
			var var2 = abs(y - x) * power
			var var3 = abs(z - y) * power
			var var4 = abs(1.0 - z) * power
			
			print("node stats: ", [var1, var2, var3, var4])
			
			node.damage *= var1
			node.time_before_punch /= var2
			node.SPEED *= var3
			node.health *= var4
			
			print("spawned node damage: ", node.damage)
			print("spawned node time before punch: ", node.time_before_punch)
			print("spawned node speed: ", node.SPEED)
			print("spawned node health: ", node.health)
		print("enemy [", node, "] instantiated from scene [", enemy_scene, "] spawned from spawner [", name, "]!")
		if "global_position" in node:
			node.global_position = global_position
		if enemy_spawn_function_name && node.has_method(enemy_spawn_function_name):
			node.call(enemy_spawn_function_name)
		get_parent().add_child(node)


static func random_spawn(power: float):
	print("random enemy spawn!")
	spawners[randi_range(0, spawners.size() - 1)].spawn(power)
