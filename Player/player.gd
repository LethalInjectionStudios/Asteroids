class_name  Player
extends CharacterBody2D

signal weapon_fired(postion: Vector2, rotation: float)
signal destroyed()

@export var acceleration: float = 10
@export var max_speed: float = 350
@export var rotation_speed: float = 250

@onready var thrust_sprite: Sprite2D = $Sprites/Thrust
@onready var weapon_audio: AudioStreamPlayer2D = $Audio/WeaponAudio
@onready var thrust_audio: AudioStreamPlayer2D = $Audio/ThrustAudio
@onready var weapon_spawn_position: Marker2D = $"Bullet Spawn"


func _physics_process(delta):
	
	var input_vector: Vector2 = Vector2(Input.get_action_strength("accelerate"), 0)
	
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("rotate_right"):
		rotate((deg_to_rad(rotation_speed*delta)))
		
	if Input.is_action_pressed("rotate_left"):
		rotate((deg_to_rad(-rotation_speed*delta)))
		
	move_and_slide()
	
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
		
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0
		
		
func _input(_event):
	if Input.is_action_just_pressed("accelerate"):
		thrust_sprite.visible = true
		if !thrust_audio.playing:
			thrust_audio.play()
	if Input.is_action_just_released("accelerate"):
		thrust_sprite.visible = false
		if thrust_audio.playing:
			thrust_audio.stop()
		
	if Input.is_action_just_pressed("fire"):
		weapon_audio.play()
		weapon_fired.emit(weapon_spawn_position.global_position, weapon_spawn_position.global_rotation)
	
	
func _on_hitbox_area_entered(area):
	if area is Asteroid:
		destroyed.emit()
		queue_free()
