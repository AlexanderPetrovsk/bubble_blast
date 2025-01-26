extends CharacterBody2D


const SPEED = 200.0
const BUBBLE_SCALE_UP = 0.4
const BUBBLE_SCALE_DOWN_RATE = 0.08

var isReady = false

var WIND_RESISTANCE = 200
var WIND_VELOCITY = 300.0

var timeElapsed = 0
var gitter = 0
var gitterMultiplier = 1.5

var isInvincible = false
var isRotating = false

var hasDied = false

@onready var death_scene: Node2D = $"../../death_scene"

@onready var camera = $Camera2D

@onready var invincibilityTimer = $InvincibilityTimer
@onready var removeGitterTimer = $RemoveGitterTimer
@onready var speedUpTimer = $SpeedUpTimer
@onready var gravity_timer: Timer = $GravityTimer
@onready var spinout_timer: Timer = $SpinoutTimer

@onready var collisionShape = $CollisionShape2D

@onready var bubble_anims = $bubble_anims
@onready var body = $bubble_anims/body
@onready var face = $bubble_anims/face
@onready var gravity_multiplier = 0.4

@onready var wind_left: AnimatedSprite2D = $bubble_anims/wind_left
@onready var wind_right: AnimatedSprite2D = $bubble_anims/wind_right
@onready var wind_down: AnimatedSprite2D = $bubble_anims/wind_down
@onready var wind_up: AnimatedSprite2D = $bubble_anims/wind_up

@onready var death: AudioStreamPlayer = $"../../sounds/death"
@onready var background_music: AudioStreamPlayer = $"../../sounds/background_music"

func _physics_process(delta: float) -> void:
	if isRotating:
		var rotations = -6.2 * delta
		bubble_anims.rotate(rotations)

	if !isReady:
		return

	if !background_music.playing:
		playMusic()
		
	velocity += get_gravity() * delta * gravity_multiplier
	
	if hasDied:
		return

	if body.scale.x < 0.45:
		face.play("angry")
	elif face.animation == "angry": 
		face.play("smile")

	if body.scale.x <= 0.35:
		die()
		return
	
	body.scale.x -= BUBBLE_SCALE_DOWN_RATE * delta
	body.scale.y -= BUBBLE_SCALE_DOWN_RATE * delta
	collisionShape.scale.x -= BUBBLE_SCALE_DOWN_RATE * delta
	collisionShape.scale.y -= BUBBLE_SCALE_DOWN_RATE * delta

	timeElapsed += 1
	if timeElapsed % 12 == 0:
		gitter = get_gitter()

	if !isRotating:
		move_bubble()
		add_wind_resistance_and_gitter(delta)

	move_and_slide()

func playMusic():
	background_music.play()

func scale_up():
	body.scale.x += BUBBLE_SCALE_UP
	body.scale.y += BUBBLE_SCALE_UP
	collisionShape.scale.x += BUBBLE_SCALE_UP
	collisionShape.scale.y += BUBBLE_SCALE_UP

func move_bubble():
	if Input.is_action_pressed("wind_left"):
		velocity.x = WIND_VELOCITY
		wind_left.play("default")
		wind_left.visible = true
	if Input.is_action_pressed("wind_right"):
		velocity.x = -WIND_VELOCITY
		wind_right.play("default")
		wind_right.visible = true
	if Input.is_action_pressed("wind_down"):
		velocity.y = -WIND_VELOCITY
		wind_down.play("default")
		wind_down.visible = true
	if Input.is_action_pressed("wind_up"):
		velocity.y = WIND_VELOCITY
		wind_up.play("default")
		wind_up.visible = true

func add_wind_resistance_and_gitter(delta):
	if velocity.y < 0:
		velocity.y += WIND_RESISTANCE * delta
		bubble_anims.position.x += gitter
		collisionShape.position.x += gitter
	if velocity.y > 0:
		velocity.y -= WIND_RESISTANCE * delta
		bubble_anims.position.x += gitter
		collisionShape.position.x += gitter
	if velocity.x < 0:
		velocity.x += WIND_RESISTANCE * delta
		bubble_anims.position.y += gitter
		collisionShape.position.y += gitter
	if velocity.x > 0:
		velocity.x -= WIND_RESISTANCE * delta
		bubble_anims.position.y += gitter
		collisionShape.position.y += gitter

func get_gitter():
	var rng = RandomNumberGenerator.new()
	rng.randomize() # Ensure different results each time
	var random_gitter = rng.randi_range(-1, 1)
	
	return random_gitter * gitterMultiplier

func die():
	death.play()
	hasDied = true
	death_scene.visible = true
	death_scene.isActive = true
	face.play('die')

func invincibility():
	isInvincible = true
	invincibilityTimer.start()
	face.play("lol")

func _on_invincibility_timer_timeout() -> void:
	isInvincible = false
	if !hasDied:
		face.play("smile")

func remove_gitter():
	gitterMultiplier = 0
	removeGitterTimer.start()
	face.play("lol")
	
func _on_remove_gitter_timer_timeout() -> void:
	gitterMultiplier = 1
	if !hasDied:
		face.play("smile")
	
func speed_up():
	WIND_VELOCITY += SPEED
	WIND_RESISTANCE += SPEED
	speedUpTimer.start()
	face.play("lol")
	
func _on_speed_up_timer_timeout() -> void:
	WIND_VELOCITY = 300
	WIND_RESISTANCE = 200
	if !hasDied:
		face.play("smile")
	
func increase_gravity():
	gravity_multiplier = 3
	face.play("sad")

func reset_gravity():
	gravity_multiplier = 0.4

func spinout():
	if !hasDied:
		face.play("wow")
	velocity.x = 500
	velocity.y = 100
	isRotating = true
	spinout_timer.start()

func _on_spinout_timer_timeout() -> void:
	isRotating = false
	if !hasDied:
		face.play("smile")
	velocity.x = 0
	velocity.y = 0
	
func _on_face_frame_changed() -> void:
	if face.animation == 'die':
		if face.frame == 3:
			body.queue_free()
		if face.frame == 13:
			face.queue_free()
			

func play_empty_anim():
	body.play('empty_start')
func _on_body_frame_changed() -> void:
	if body.animation == "empty_start" and body.frame == 19:
		body.play("empty_loop")
