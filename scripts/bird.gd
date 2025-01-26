extends Area2D

const BIRD_SPEED = 500

@export var isRight = false
@onready var animated_sprite = $AnimatedSprite2D
@onready var bubble: CharacterBody2D = $"../bubble"
@onready var camera_2d: Camera2D = $"../bubble/Camera2D"

@onready var bird_sound: AudioStreamPlayer = $"../../sounds/bird_sound"

var isActive = false
var direction = -1
var soundHasPlayed = false
func _physics_process(delta: float) -> void:
	isActive = (global_position.x - bubble.global_position.x) < 1500
	if !isActive:
		return
	
	if !bird_sound.playing and !soundHasPlayed:	
		bird_sound.play()
		soundHasPlayed = true

	if isRight:
		direction = 1
		animated_sprite.flip_h = true
	
	position.x += direction * BIRD_SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if !body.isInvincible:
		if body.has_method('die'):
			body.die()
