extends Node2D


const DROPPING_ENEMY = preload("res://brawl/dropping_enemy.tscn")
const TARGET = preload("res://target/target.tscn")

@onready var level_manager: LevelManager = $/root/Main/LevelManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dropping_enemy = DROPPING_ENEMY.instantiate()
	add_child(dropping_enemy)
	dropping_enemy.add_child(TARGET.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
