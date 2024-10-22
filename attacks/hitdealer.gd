extends Area2D
class_name HitDealer


signal hit_landed(hitbox: HitBox, damage: float, hitbox_died: bool)
signal attack_direction_needed

@export var damage: int = 10

var attack_direction = Vector2()


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	#for node in get_children():
	#	if node is Area2D:
	#		node.area_entered.connect(func(area: Area2D): if area is HitBox: attack_direction_needed.emit(); area.tell_to_dodge(attack_direction))
	#child_entered_tree.connect(func(node: Node): if node is Area2D: node.area_entered.connect(func(area: Area2D): if area is HitBox: attack_direction_needed.emit(); area.tell_to_dodge(attack_direction)))


func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		hit_landed.emit(area as HitBox, damage, (area as HitBox).hit(self, damage))
