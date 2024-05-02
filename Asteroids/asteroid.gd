class_name Asteroid
extends Area2D

signal asteroid_destroyed(pos: Vector2, size: Globals.Size)

@onready var explosion_audio: AudioStreamPlayer2D = $Audio/Explosion
@onready var sprite: Sprite2D = $Sprite2D

var size: Globals.Size
var screen_size

@export var hitbox_component: HitBoxComponent
var asteroid: PackedScene = preload("res://Asteroids/asteroid.tscn")

var _rotation_speed: float = randf_range(15, 55)
var _movement_speed: int = randi_range(50, 150)

func _ready():
	_connect_signals()
	
	
func _process(delta):
	position += Vector2.RIGHT.rotated(rotation) * _movement_speed * delta
	sprite.rotate(deg_to_rad(_rotation_speed*delta))
	pass
	
func _destroy():
	explosion_audio.play()
	sprite.visible = false
	hitbox_component.queue_free()
	$CollisionShape2D.queue_free()
	asteroid_destroyed.emit(global_position, size)
	
	
func setup(target: Vector2):

	look_at(target)
	
	match size:
		Globals.Size.LARGE:
			scale = Vector2(1, 1)
		Globals.Size.MEDIUM:
			scale = Vector2(.5, .5)
		Globals.Size.SMALL:
			scale = Vector2(.25, .25)
		
		
func _connect_signals():
	if hitbox_component:
		hitbox_component.hitbox_component_hit.connect(_on_hitbox_hit)
		
		
func _on_hitbox_hit():
	_destroy()


func _on_explosion_finished():
	queue_free()
