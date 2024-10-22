extends RigidBody2D


func _on_body_entered(body: Node) -> void:
	get_child(1).reparent.call_deferred($"..")
	queue_free()
