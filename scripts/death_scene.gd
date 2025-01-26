extends Node2D

@onready var camera_2d: Camera2D = $"../world/bubble/Camera2D"
@onready var animated_sprite: AnimatedSprite2D = $Button/AnimatedSprite2D

const min_camera_pos = 750
const max_camera_pos = 5250

var isActive = false
var isIntroPlayed = false
func _process(delta: float) -> void:
	var h_camera_pos = camera_2d.global_transform.origin.x
	
	if h_camera_pos > min_camera_pos:
		position.x = min(h_camera_pos, camera_2d.limit_right - 750)
	else:
		position.x = min_camera_pos

	if isActive and !isIntroPlayed:
		animated_sprite.play('intro')

func _on_button_pressed() -> void:
	animated_sprite.play('outro')

func _on_animated_sprite_2d_animation_finished() -> void:
	print(animated_sprite.animation)
	if animated_sprite.animation == 'intro':
		isIntroPlayed = true
		animated_sprite.play('loop')

	if animated_sprite.animation == 'outro':
		get_tree().reload_current_scene()
