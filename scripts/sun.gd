extends Node2D


@onready var camera_2d: Camera2D = $"../world/bubble/Camera2D"

const min_camera_pos = 750
const max_camera_pos = 5250

func _process(delta: float) -> void:
	pass
	#var levelLength = camera_2d.limit_right - camera_2d.limit_left
	#var cameraLength = 300
	#
	##sun/cam = campos/level
	#var cameraPosition = camera_2d.global_position.x
	#var predictedPos = (cameraPosition/levelLength) * cameraLength + (cameraPosition - 500)
	#if predictedPos > 150 and predictedPos < 5850:
		#position.x = predictedPos
