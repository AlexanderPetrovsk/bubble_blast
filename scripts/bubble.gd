extends CharacterBody2D


const SPEED = 200.0
const BUBBLE_SCALE_UP = 0.4
const BUBBLE_SCALE_DOWN_RATE = 0

const end_scene_X = 17159
const end_scene_Y = 433


var isReady = false

var WIND_RESISTANCE = 150
var WIND_VELOCITY = 2000.0

var timeElapsed = 0
var gitter = 0
var gitterMultiplier = 1

var isInvincible = false
var isRotating = false

var hasDied = false
var reachedEnd = false
@onready var death_scene: Node2D = $"../../death_scene"

@onready var camera = $Camera2D

@onready var invincibilityTimer = $InvincibilityTimer
@onready var removeGitterTimer = $RemoveGitterTimer
@onready var speedUpTimer = $SpeedUpTimer
@onready var gravity_timer: Timer = $GravityTimer
@onready var spinout_timer: Timer = $SpinoutTimer
@onready var end_game_timer: Timer = $EndGameTimer

@onready var collisionShape = $CollisionShape2D

@onready var bubble_anims = $bubble_anims
@onready var body = $bubble_anims/body
@onready var face = $bubble_anims/face
@onready var gravity_multiplier = 0.4

@onready var wind_left: AnimatedSprite2D = $bubble_anims/wind_left
@onready var wind_right: AnimatedSprite2D = $bubble_anims/wind_right
@onready var wind_down: AnimatedSprite2D = $bubble_anims/wind_down
@onready var wind_up: AnimatedSprite2D = $bubble_anims/wind_up
@onready var wind_up_left: AnimatedSprite2D = $bubble_anims/wind_up_left
@onready var wind_up_right: AnimatedSprite2D = $bubble_anims/wind_up_right
@onready var wind_down_left: AnimatedSprite2D = $bubble_anims/wind_down_left
@onready var wind_down_right: AnimatedSprite2D = $bubble_anims/wind_down_right

@onready var death: AudioStreamPlayer = $"../../sounds/death"
@onready var background_music: AudioStreamPlayer = $"../../sounds/background_music"
@onready var end_scene: Node2D = $"../../end_scene"

@onready var bubble: CharacterBody2D = $"."

func _physics_process(delta: float) -> void:
	if reachedEnd:
		return
 
	if global_position.x >= 16300:
		end_game(delta)
		return

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
	
	addAnimations()
	move_and_slide()

func playMusic():
	background_music.play()

func scale_up():
	body.scale.x += BUBBLE_SCALE_UP
	body.scale.y += BUBBLE_SCALE_UP
	collisionShape.scale.x += BUBBLE_SCALE_UP
	collisionShape.scale.y += BUBBLE_SCALE_UP

func addAnimations():
	pass

func move_bubble():
	var playingAnimation = null

	if Input.is_action_pressed("wind_left") and !Input.is_action_pressed("wind_down") and !Input.is_action_pressed("wind_up"):
		velocity.x = WIND_VELOCITY
		playingAnimation = wind_left
	if Input.is_action_pressed("wind_right") and !Input.is_action_pressed("wind_down") and !Input.is_action_pressed("wind_up"):
		velocity.x = -WIND_VELOCITY
		playingAnimation = wind_right
	if Input.is_action_pressed("wind_down"):
		velocity.y = -WIND_VELOCITY
		playingAnimation = wind_down
	if Input.is_action_pressed("wind_up"):
		velocity.y = WIND_VELOCITY
		playingAnimation = wind_up
	if Input.is_action_pressed("wind_up") and Input.is_action_pressed("wind_left"):
		velocity.y = WIND_VELOCITY
		velocity.x = WIND_VELOCITY
		playingAnimation = wind_up_left
	if Input.is_action_pressed("wind_up") and Input.is_action_pressed("wind_right"):
		velocity.y = WIND_VELOCITY
		velocity.x = -WIND_VELOCITY
		playingAnimation = wind_up_right
	if Input.is_action_pressed("wind_down") and Input.is_action_pressed("wind_left"):
		velocity.y = -WIND_VELOCITY
		velocity.x = WIND_VELOCITY
		playingAnimation = wind_down_left
	if Input.is_action_pressed("wind_down") and Input.is_action_pressed("wind_right"):
		velocity.y = -WIND_VELOCITY
		velocity.x = -WIND_VELOCITY
		playingAnimation = wind_down_right

	if playingAnimation != null:
		playingAnimation.play('default')
		playingAnimation.visible = true

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
	pass
#
	#death.play()
	#hasDied = true
	#death_scene.visible = true
	#death_scene.isActive = true
	#face.play('die')
	
func end_game(delta):
	velocity.x = 0
	velocity.y = 0
	
	#if global_position.x < end_scene_X:
		#position.x += 100 * delta * 2
	#if global_position.x > end_scene_X:
		#position.x -= 100 * delta * 2
	#if global_position.y < end_scene_Y:
		#position.y += 100 * delta * 2
	#if global_position.y > end_scene_Y:
		#position.y -= 100 * delta * 2
	
	var tween = create_tween()
	tween.tween_property(self, 'global_position', Vector2(end_scene_X, end_scene_Y), 3)

	end_game_timer.start()
	reachedEnd = true

func _on_end_game_timer_timeout() -> void:
	end_scene.play("default")

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
