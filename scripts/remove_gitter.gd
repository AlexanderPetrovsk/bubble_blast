extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('remove_gitter'):
		body.remove_gitter()
		queue_free()
