extends Area2D

@onready var consume_gitter: AudioStreamPlayer = $"../../../sounds/consume_gitter"

func _on_body_entered(body: Node2D) -> void:
	consume_gitter.play()
	
	if body.has_method('remove_gitter'):
		body.remove_gitter()
		queue_free()
