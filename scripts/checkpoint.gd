extends Area2D

@onready var consume_scale: AudioStreamPlayer = $"../../../sounds/consume_scale"

func _on_body_entered(body: Node2D) -> void:
	consume_scale.play()

	if (body.has_method('scale_up')):
		body.scale_up()
		queue_free()
