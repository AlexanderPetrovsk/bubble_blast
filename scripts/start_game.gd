extends Node2D

@onready var bubble: CharacterBody2D = $"../world/bubble"

func _on_animated_sprite_2d_2_animation_finished() -> void:
	bubble.isReady = true
	queue_free()
