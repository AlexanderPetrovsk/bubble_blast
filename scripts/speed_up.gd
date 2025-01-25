extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('speed_up'):
		body.speed_up()
		queue_free()
