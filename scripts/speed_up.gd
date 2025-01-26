extends Area2D

@onready var consume_speed: AudioStreamPlayer = $"../../../sounds/consume_speed"

func _on_body_entered(body: Node2D) -> void:
	consume_speed.play()

	if body.has_method('speed_up'):
		body.speed_up()
		queue_free()
