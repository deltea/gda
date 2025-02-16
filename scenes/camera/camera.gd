class_name Camera extends Camera3D

const CAMERA_SPEED = 8.0
const TARGET_LOOK_OFFSET = Vector3(0, 1.0, 0)
const TARGET_OFFSET = Vector3(0, 5.0, 7.0)

@export var target: Node3D

func _ready() -> void:
	global_position = getPosition()
	# global_rotation = getRotation()

func _process(delta: float) -> void:
	global_position = global_position.lerp(getPosition(), CAMERA_SPEED * delta)
	look_at(target.global_position + TARGET_LOOK_OFFSET)
	# global_rotation = global_rotation.lerp(getRotation(), CAMERA_SPEED * delta)

func getPosition() -> Vector3:
	return target.global_position + TARGET_OFFSET

# func getRotation() -> Vector3:
# 	return
