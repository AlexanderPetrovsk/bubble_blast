extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if (body.has_method('scale_up')):
		body.scale_up()
		queue_free()
