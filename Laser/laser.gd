class_name Laser
extends Area2D

var _speed: int = 500


func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * _speed * delta

func setup(spawn_position: Vector2, spawn_rotation: float) -> void:
	global_position = spawn_position
	global_rotation = spawn_rotation


func _on_area_entered(area):
	if area is HitBoxComponent:
		area.hit()
		queue_free()
