extends CharacterBody2D


const SPEED = 300.0
const BUBBLE_SCALE_UP = 0.4
const BUBBLE_SCALE_DOWN_RATE = 0

var WIND_RESISTANCE = 300
var WIND_VELOCITY = 400.0

var timeElapsed = 0
var gitter = 0
var gitterMultiplier = 2

var isInvincible = false

var hasDied = false

var isReady = false	

@onready var death_scene = $"../death_scene"

@onready var camera = $Camera2D

@onready var invincibilityTimer = $InvincibilityTimer
@onready var removeGitterTimer = $RemoveGitterTimer
@onready var speedUpTimer = $SpeedUpTimer
@onready var gravity_timer: Timer = $GravityTimer

@onready var collisionShape = $CollisionShape2D

@onready var bubble_anims = $bubble_anims
@onready var body = $bubble_anims/body
@onready var face = $bubble_anims/face
@onready var gravity_multiplier = 0.4

func _physics_process(delta: float) -> void:
	if !isReady:
		return

	velocity += get_gravity() * delta * gravity_multiplier
	
	if hasDied:
		return

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

	move_bubble()

	add_wind_resistance_and_gitter(delta)

	move_and_slide()


func scale_up():
	body.scale.x += BUBBLE_SCALE_UP
	body.scale.y += BUBBLE_SCALE_UP
	collisionShape.scale.x += BUBBLE_SCALE_UP
	collisionShape.scale.y += BUBBLE_SCALE_UP

func move_bubble():
	if Input.is_action_pressed("wind_left"):
		velocity.x = WIND_VELOCITY
	if Input.is_action_pressed("wind_right"):
		velocity.x = -WIND_VELOCITY
	if Input.is_action_pressed("wind_down"):
		velocity.y = -WIND_VELOCITY
	if Input.is_action_pressed("wind_up"):
		velocity.y = WIND_VELOCITY

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
	gitterMultiplier = 2
	if !hasDied:
		face.play("smile")
	
func speed_up():
	WIND_VELOCITY += 400
	WIND_RESISTANCE += 400
	speedUpTimer.start()
	face.play("lol")
	
func _on_speed_up_timer_timeout() -> void:
	WIND_VELOCITY = 400
	WIND_RESISTANCE = 300
	if !hasDied:
		face.play("smile")
	
func increase_gravity():
	gravity_multiplier = 3
	face.play("sad")

func reset_gravity():
	gravity_multiplier = 0.4
	if !hasDied:
		face.play("smile")
	

func spinout():
	print('spin')

func _on_face_frame_changed() -> void:
	if face.animation == 'die':
		if face.frame == 3:
			body.queue_free()
		if face.frame == 13:
			face.queue_free()
			
