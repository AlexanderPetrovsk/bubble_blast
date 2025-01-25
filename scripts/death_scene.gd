extends Node2D
@onready var camera: Camera2D = $"../bubble/Camera2D"

@onready var animated_sprite: AnimatedSprite2D = $Button/AnimatedSprite2D

var isActive = false
var isIntroPlayed = false
func _process(delta: float) -> void:
	position.x = min(camera.global_transform.origin.x, 10000000)
	if isActive and !isIntroPlayed:
		animated_sprite.play('intro')

func _on_button_pressed() -> void:
	animated_sprite.play('outro')

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == 'intro':
		isIntroPlayed = true
		animated_sprite.play('loop')

	if animated_sprite.animation == 'outro':
		get_tree().reload_current_scene()
