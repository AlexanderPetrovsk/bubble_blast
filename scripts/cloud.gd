extends Area2D

@onready var timeElapsed = 0 
@onready var rain: AnimatedSprite2D = $Rain/rain
@onready var collision_rain: CollisionShape2D = $Rain/CollisionRain

var timesPlayed = 0
func _physics_process(delta: float) -> void:
	timeElapsed += 1
	if timeElapsed % 420 == 0:
		rain.play("rain_start")

func _on_rain_body_entered(body: Node2D) -> void:
	if body.has_method("increase_gravity") and !body.hasDied:
		body.increase_gravity()
		
func _on_rain_body_exited(body: Node2D) -> void:
	if body.has_method("reset_gravity") and !body.hasDied:
		body.reset_gravity()	

func _on_rain_animation_finished() -> void:
	if rain.animation == "rain_start":
		rain.play("rain")
	if rain.animation == "rain_stop":
		rain.play("no_rain")

func _on_rain_frame_changed() -> void:
	if rain.animation == 'rain' and rain.frame == 41:
		rain.play("rain_stop")

	if rain.animation == 'rain_start' and rain.frame == 3:
		collision_rain.disabled = false
	if rain.animation == 'rain_stop' and rain.frame == 3:
		collision_rain.disabled = true

func _on_cloud_body_entered(body: Node2D) -> void:
	if !body.isInvincible:
		if body.has_method('die'):
			body.die()
