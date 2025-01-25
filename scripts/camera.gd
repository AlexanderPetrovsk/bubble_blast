extends Camera2D
#
#
#const CAMERA_SPEED = 200
#const CAMERA_PAN_SPEED = 600
#
#const ORIGINAL_LIMIT = 1150
#const EXTENDED_LIMIT = 1600
#
#const CAMERA_BREAKPOINT = 800
#@onready var bubble = $"../bubble"
#func _physics_process(delta: float) -> void:
	##position.y -= CAMERA_SPEED * delta
	#if (bubble.position.x > CAMERA_BREAKPOINT):
		#position.x += CAMERA_PAN_SPEED * delta
		#limit_right = EXTENDED_LIMIT
	#elif limit_right > ORIGINAL_LIMIT:
		#limit_right -= CAMERA_PAN_SPEED * delta
		#position.x -= CAMERA_SPEED * delta
#
	#if (bubble.position.x < -CAMERA_BREAKPOINT):
		#position.x -= CAMERA_PAN_SPEED * delta
		#limit_left = -EXTENDED_LIMIT
	#elif limit_left < -ORIGINAL_LIMIT:
		#limit_left += CAMERA_PAN_SPEED * delta
		#position.x += CAMERA_PAN_SPEED * delta
