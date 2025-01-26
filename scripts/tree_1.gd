extends Area2D

@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2

func _on_body_entered(body: Node2D) -> void:
	if !body.isInvincible:
		if body.has_method('die'):
			body.die()

func play_tree_shake():
	animated_sprite_2d_2.play('default')
