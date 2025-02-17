class_name NPC extends StaticBody3D

const HANDS_OFFSET = Vector3(0, 0.5, 0)
const IDLE_SPEED = 5.0
const IDLE_MAGNITUDE = 0.03
const LOOK_SPEED = 5.0

@onready var head: MeshInstance3D = $Head
@onready var hands: Node3D = $Hands

var original_head_pos: Vector3
var noticing = false

func _ready() -> void:
	original_head_pos = head.position

func _process(delta: float) -> void:
	hands.global_position = hands.global_position.lerp(global_position + HANDS_OFFSET, 1)
	hands.global_rotation.y = lerp_angle(hands.global_rotation.y, rotation.y, 1)
	head.position.y = original_head_pos.y + sin(Clock.time * IDLE_SPEED) * IDLE_MAGNITUDE

	var look_direction = (head.global_position - RoomManager.current_room.player.head.global_position).normalized()
	var look_angle = -Vector2(look_direction.x, look_direction.z).angle() - PI/2
	var look_degrees = rad_to_deg(look_angle)
	if noticing && (-90 < look_degrees && look_degrees < 90):
		head.rotation.y = lerp_angle(head.rotation.y, look_angle, LOOK_SPEED * delta)
	else:
		head.rotation.y = lerp_angle(head.rotation.y, 0, LOOK_SPEED * delta)

func _on_notice_area_body_entered(body: Node3D) -> void:
	if body is Player:
		noticing = true
		

func _on_notice_area_body_exited(body: Node3D) -> void:
	if body is Player: noticing = false
