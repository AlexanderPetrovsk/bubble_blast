extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2
@onready var tree_shake_timer: Timer = $TreeShakeTimer

var maxGrowth = 850
var isAnimationPlaying = false

func _on_animated_sprite_2d_frame_changed() -> void:
	if !isAnimationPlaying:
		return

	if collision_shape_2d.transform.y.y < maxGrowth:
		collision_shape_2d.position.y += 5.35
		collision_shape_2d.transform.y += Vector2(0, 25)
	
	if animated_sprite_2d.frame > 20 and animated_sprite_2d.frame < 80:
		collision_shape_2d_2.visible = true
	else:
		collision_shape_2d_2.visible = false

	if animated_sprite_2d.frame > 80:
		collision_shape_2d.position.y -= 15
		collision_shape_2d.transform.y -= Vector2(0, 71.5)


func _on_show_body_entered(body: Node2D) -> void:
	if get_parent().has_method('play_tree_shake'):
		get_parent().play_tree_shake()
		tree_shake_timer.start()
		return

	isAnimationPlaying = true
	animated_sprite_2d.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method('die'):
		body.die()


func _on_tree_shake_timer_timeout() -> void:
	isAnimationPlaying = true
	animated_sprite_2d.play("default")
