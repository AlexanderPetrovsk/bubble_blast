extends Node2D

@onready var bubble: CharacterBody2D = $"../world/bubble"
@onready var start_game: Node2D = $"."

func _on_animated_sprite_2d_animation_finished() -> void:
	start_game.visible = false
	bubble.isReady = true
	bubble.play_empty_anim()
	
