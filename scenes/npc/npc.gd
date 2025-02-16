class_name NPC extends StaticBody3D

const HANDS_OFFSET = Vector3(0, 0.5, 0)

@onready var hands: Node3D = $Hands

func _process(delta: float) -> void:
	hands.global_position = hands.global_position.lerp(global_position + HANDS_OFFSET, 1)
	hands.global_rotation.y = lerp_angle(hands.global_rotation.y, rotation.y, 1)
