class_name HitBoxComponent
extends Area2D

signal hitbox_component_hit()

func hit():
	hitbox_component_hit.emit()
	
