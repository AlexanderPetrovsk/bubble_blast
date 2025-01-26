extends Area2D

@onready var consume_invincibility: AudioStreamPlayer = $"../../../sounds/consume_invincibility"

func _on_body_entered(body: Node2D) -> void:
	consume_invincibility.play()
	
	if body.has_method('invincibility'):
		body.invincibility()
		queue_free()
