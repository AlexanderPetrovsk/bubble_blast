extends Area2D

const BIRD_SPEED = 700

@export var isRight = false
@onready var animated_sprite = $AnimatedSprite2D

var direction = -1
func _physics_process(delta: float) -> void:
	if isRight:
		direction = 1
		animated_sprite.flip_h = true

	position.x += direction * BIRD_SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if !body.isInvincible:
		if body.has_method('die'):
			body.die()
