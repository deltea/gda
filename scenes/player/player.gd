class_name Player extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 10.0
const GRAVITY = 20.0
const ROTATION_SPEED = 10.0
const HAND_SPEED = 20.0
const WADDLE_SPEED = 20.0
const WADDLE_MAGNITUDE = 7.0
const WADDLE_RESET_SPEED = 10.0
const IDLE_SPEED = 5.0
const IDLE_MAGNITUDE = 0.03

@onready var visuals: Node3D = $Visuals
@onready var head: MeshInstance3D = $Visuals/Head
@onready var hands: Node3D = $Visuals/Hands

var original_head_pos: Vector3
var original_hands_pos: Vector3

func _enter_tree() -> void:
	RoomManager.current_room.player = self

func _ready() -> void:
	original_head_pos = head.position
	original_hands_pos = hands.global_position

func _physics_process(delta: float) -> void:
	# add the gravity
	if not is_on_floor():
		velocity += Vector3.DOWN * GRAVITY * delta

	# handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# get the input direction and handle the movement/deceleration
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# rotate towards direction
		visuals.rotation.y = lerp_angle(visuals.rotation.y, -Vector2(direction.x, direction.z).angle() + PI/2, ROTATION_SPEED * delta)

		# walking animation
		if is_on_floor():
			visuals.rotation_degrees.z = sin(Clock.time * WADDLE_SPEED) * WADDLE_MAGNITUDE
		else:
			visuals.rotation_degrees.z = lerp(visuals.rotation_degrees.z, 0.0, WADDLE_RESET_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

		visuals.rotation_degrees.z = lerp(visuals.rotation_degrees.z, 0.0, WADDLE_RESET_SPEED * delta)

		if is_on_floor():
			head.position.y = original_head_pos.y + sin(Clock.time * IDLE_SPEED) * IDLE_MAGNITUDE

	# make hands follow body
	hands.global_position = hands.global_position.lerp(visuals.global_position, 1)#HAND_SPEED * delta)
	hands.global_rotation.y = lerp_angle(hands.global_rotation.y, visuals.rotation.y, HAND_SPEED * delta)

	move_and_slide()
