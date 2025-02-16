class_name Room extends Node3D

var player: Player

func _enter_tree() -> void:
	RoomManager.current_room = self
